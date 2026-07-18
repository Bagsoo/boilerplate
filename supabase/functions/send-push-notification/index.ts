import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// ① FCM v1 API용 액세스 토큰 가져오기
async function getAccessToken(serviceAccount: any): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  
  const header = { alg: "RS256", typ: "JWT" };
  const payload = {
    iss: serviceAccount.client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600,
  };

  // JWT 생성
  const encoder = new TextEncoder();
  const headerB64 = btoa(JSON.stringify(header));
  const payloadB64 = btoa(JSON.stringify(payload));
  const signingInput = `${headerB64}.${payloadB64}`;

  const privateKey = await crypto.subtle.importKey(
    "pkcs8",
    pemToArrayBuffer(serviceAccount.private_key),
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"]
  );

  const signature = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    privateKey,
    encoder.encode(signingInput)
  );

  const jwt = `${signingInput}.${btoa(String.fromCharCode(...new Uint8Array(signature)))}`;

  // 액세스 토큰 요청
  const tokenResponse = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${jwt}`,
  });

  const tokenData = await tokenResponse.json();
  return tokenData.access_token;
}

function pemToArrayBuffer(pem: string): ArrayBuffer {
  const base64 = pem
    .replace(/-----BEGIN PRIVATE KEY-----/, "")
    .replace(/-----END PRIVATE KEY-----/, "")
    .replace(/\n/g, "");
  const binary = atob(base64);
  const buffer = new ArrayBuffer(binary.length);
  const view = new Uint8Array(buffer);
  for (let i = 0; i < binary.length; i++) {
    view[i] = binary.charCodeAt(i);
  }
  return buffer;
}

// ② FCM으로 푸시 전송
async function sendFcmPush(
  token: string,
  title: string,
  body: string,
  data: any,
  accessToken: string,
  projectId: string
) {
  const response = await fetch(
    `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify({
        message: {
          token,
          notification: { title, body },
          data: {
            ...data,
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
            route: record.data?.route ?? '/notifications',  // ← 이동할 경로
          },
          android: {
            priority: "high",
            notification: { sound: "default" },
          },
          apns: {
            payload: {
              aps: { sound: "default", badge: 1 },
            },
          },
        },
      }),
    }
  );
  return response.json();
}

// ③ 메인 핸들러
serve(async (req) => {
  try {
    const { record } = await req.json();   // DB Webhook에서 넘어오는 데이터

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    const serviceAccount = JSON.parse(Deno.env.get("FIREBASE_SERVICE_ACCOUNT")!);
    const accessToken = await getAccessToken(serviceAccount);

    // receiver_id의 device_tokens 가져오기
    const { data: tokens } = await supabase
      .from("device_tokens")
      .select("token")
      .eq("user_id", record.receiver_id);

    if (!tokens || tokens.length === 0) {
      return new Response(JSON.stringify({ message: "토큰 없음" }), {
        status: 200,
      });
    }

    // 모든 기기에 푸시 전송
    const results = await Promise.all(
      tokens.map((t: any) =>
        sendFcmPush(
          t.token,
          record.title,
          record.body,
          record.data,
          accessToken,
          serviceAccount.project_id
        )
      )
    );

    return new Response(JSON.stringify({ success: true, results }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (e) {
    return new Response(JSON.stringify({ error: e.message }), {
      status: 500,
    });
  }
});