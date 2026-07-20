create table public.app_config (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,
  value text not null,
  created_at timestamptz default now()
);

-- RLS 활성화
alter table public.app_config enable row level security;

-- 모든 사용자 조회 가능 (인증 없이도)
create policy "app_config 공개 조회"
on public.app_config for select
using (true);

-- 초기 데이터 insert
insert into public.app_config (key, value) values
  ('min_version_android', '1.0.0'),
  ('min_version_ios', '1.0.0');