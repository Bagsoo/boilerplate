-- =============================================
-- 1. device_tokens 테이블
-- =============================================
create table public.device_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  token text not null,
  platform text not null,        -- 'ios' or 'android'
  device_name text,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  last_used_at timestamptz default now(),
  unique(user_id, token)         -- 같은 토큰 중복 방지
);

alter table public.device_tokens enable row level security;

create policy "본인 토큰만 관리"
on public.device_tokens for all
using (auth.uid() = user_id);

-- =============================================
-- 2. notifications 테이블
-- =============================================
create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  receiver_id uuid references auth.users(id) on delete cascade,
  sender_id uuid references auth.users(id) on delete set null,
  title text not null,
  body text not null,
  type text not null,            -- 'chat', 'follow', 'like' 등
  data jsonb,                    -- 추가 데이터 (화면 이동용)
  is_read boolean default false,
  created_at timestamptz default now()
);

alter table public.notifications enable row level security;

create policy "본인 알림만 조회"
on public.notifications for select
using (auth.uid() = receiver_id);

create policy "본인 알림만 수정"
on public.notifications for update
using (auth.uid() = receiver_id);

-- =============================================
-- 3. notifications insert RPC
-- =============================================
create or replace function send_notification(
  p_receiver_id uuid,
  p_title text,
  p_body text,
  p_type text,
  p_data jsonb default null,
  p_sender_id uuid default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.notifications (
    receiver_id, sender_id, title, body, type, data
  ) values (
    p_receiver_id, p_sender_id, p_title, p_body, p_type, p_data
  );
end;
$$;

-- 방법 A: 일반 사용자 호출 차단 (서버/Edge Function만 사용)
revoke execute on function send_notification(uuid, text, text, text, jsonb, uuid) from public, anon, authenticated;


-- =============================================
-- 5. 토큰 등록 RPC
--    같은 토큰이 다른 계정에 남아 있으면 정리하고 현재 계정으로 등록
-- =============================================
create or replace function register_device_token(
  p_token text,
  p_platform text,
  p_device_name text
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'not authenticated';
  end if;

  -- 다른 계정에 남아 있는 같은 토큰 제거
  delete from public.device_tokens
  where token = p_token and user_id <> auth.uid();

  -- 현재 계정으로 upsert
  insert into public.device_tokens (user_id, token, platform, device_name, updated_at, last_used_at)
  values (auth.uid(), p_token, p_platform, p_device_name, now(), now())
  on conflict (user_id, token)
  do update set
    platform = excluded.platform,
    device_name = excluded.device_name,
    updated_at = now(),
    last_used_at = now();
end;
$$;

-- 로그인한 사용자만 호출 가능 (anon 차단)
revoke execute on function register_device_token(text, text, text) from public, anon;
grant execute on function register_device_token(text, text, text) to authenticated;

-- =============================================
-- 6. 회원탈퇴 소프트 딜리트 함수
-- =============================================
create or replace function delete_user()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.profiles
  set
    is_deleted = true,
    deleted_at = now()
  where id = auth.uid();

  delete from public.device_tokens where user_id = auth.uid();
end;
$$;
