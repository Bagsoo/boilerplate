-- =============================================
-- 1. profiles 테이블 생성
-- =============================================
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  nickname text not null,
  profile_image text,
  is_deleted boolean default false,
  deleted_at timestamptz,
  terms_agreed_at timestamptz,
  privacy_agreed_at timestamptz,
  push_notification_enabled boolean default true,
  marketing_notification_enabled boolean default false,
  created_at timestamptz default now()
);

-- =============================================
-- 2. RLS 활성화
-- =============================================
alter table public.profiles enable row level security;

-- =============================================
-- 3. RLS 정책
-- =============================================

-- 본인 프로필 조회
create policy "본인 프로필 조회 가능"
on public.profiles for select
using (auth.uid() = id);

-- 본인 프로필 수정
create policy "본인 프로필 수정 가능"
on public.profiles for update
using (auth.uid() = id);

-- 본인 프로필 insert
create policy "본인 프로필 insert 가능"
on public.profiles for insert
with check (auth.uid() = id);

-- =============================================
-- 4. 회원가입 시 profiles 자동 생성 트리거
-- =============================================
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, nickname)
  values (
    new.id,
    coalesce(
      new.raw_user_meta_data->>'nickname',
      new.raw_user_meta_data->>'name',
      split_part(new.email, '@', 1)
    )
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- =============================================
-- 5. Storage 버킷 정책
-- =============================================

-- 본인 파일만 업로드 가능
create policy "본인 아바타 업로드"
on storage.objects for insert
with check (
  bucket_id = 'avatars' and
  auth.uid()::text = (storage.foldername(name))[1]
);

-- 본인 파일만 수정 가능
create policy "본인 아바타 수정"
on storage.objects for update
using (
  bucket_id = 'avatars' and
  auth.uid()::text = (storage.foldername(name))[1]
);

create policy "본인 아바타 삭제"
on storage.objects for delete
using (
  bucket_id = 'avatars' and
  auth.uid()::text = (storage.foldername(name))[1]
);

-- 모든 사람이 아바타 조회 가능
create policy "아바타 공개 조회"
on storage.objects for select
using (bucket_id = 'avatars');

-- =============================================
-- 7. 30일 지난 탈퇴 유저 완전 삭제 (참고용)
-- =============================================
-- delete from auth.users
-- where id in (
--   select id from public.profiles
--   where is_deleted = true
--   and deleted_at < now() - interval '30 days'
-- );