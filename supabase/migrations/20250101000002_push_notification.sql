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
as $$
begin
  insert into public.notifications (
    receiver_id, sender_id, title, body, type, data
  ) values (
    p_receiver_id, p_sender_id, p_title, p_body, p_type, p_data
  );
end;
$$;