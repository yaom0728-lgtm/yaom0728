-- 보안 정책 (RLS)
-- 실행 순서: ① Supabase > Authentication > Users 에서 관리자 계정 생성
--            ② supabase_setup.sql 실행
--            ③ 이 파일 실행
-- 계정을 먼저 만들지 않으면 관리자가 로그인할 수 없다.
--
-- 원칙: 읽기는 공개, 쓰기는 로그인한 관리자(authenticated)만.
--       예외 — inquiries 는 보내기만 anon 허용, 읽기는 관리자 전용.

-- profile
ALTER TABLE public.profile ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "profile_all"    ON public.profile;
DROP POLICY IF EXISTS "profile_read"   ON public.profile;
DROP POLICY IF EXISTS "profile_insert" ON public.profile;
DROP POLICY IF EXISTS "profile_update" ON public.profile;
DROP POLICY IF EXISTS "profile_delete" ON public.profile;
CREATE POLICY "profile_read"   ON public.profile FOR SELECT USING (true);
CREATE POLICY "profile_insert" ON public.profile FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "profile_update" ON public.profile FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "profile_delete" ON public.profile FOR DELETE TO authenticated USING (true);

-- notice
ALTER TABLE public.notice ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "notice_all"    ON public.notice;
DROP POLICY IF EXISTS "notice_read"   ON public.notice;
DROP POLICY IF EXISTS "notice_insert" ON public.notice;
DROP POLICY IF EXISTS "notice_update" ON public.notice;
DROP POLICY IF EXISTS "notice_delete" ON public.notice;
CREATE POLICY "notice_read"   ON public.notice FOR SELECT USING (true);
CREATE POLICY "notice_insert" ON public.notice FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "notice_update" ON public.notice FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "notice_delete" ON public.notice FOR DELETE TO authenticated USING (true);

-- schedule
ALTER TABLE public.schedule ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "schedule_all"    ON public.schedule;
DROP POLICY IF EXISTS "schedule_read"   ON public.schedule;
DROP POLICY IF EXISTS "schedule_insert" ON public.schedule;
DROP POLICY IF EXISTS "schedule_update" ON public.schedule;
DROP POLICY IF EXISTS "schedule_delete" ON public.schedule;
CREATE POLICY "schedule_read"   ON public.schedule FOR SELECT USING (true);
CREATE POLICY "schedule_insert" ON public.schedule FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "schedule_update" ON public.schedule FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "schedule_delete" ON public.schedule FOR DELETE TO authenticated USING (true);

-- songs
ALTER TABLE public.songs ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "songs_all"    ON public.songs;
DROP POLICY IF EXISTS "songs_read"   ON public.songs;
DROP POLICY IF EXISTS "songs_insert" ON public.songs;
DROP POLICY IF EXISTS "songs_update" ON public.songs;
DROP POLICY IF EXISTS "songs_delete" ON public.songs;
CREATE POLICY "songs_read"   ON public.songs FOR SELECT USING (true);
CREATE POLICY "songs_insert" ON public.songs FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "songs_update" ON public.songs FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "songs_delete" ON public.songs FOR DELETE TO authenticated USING (true);

-- original_songs (VOD)
ALTER TABLE public.original_songs ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "original_songs_all"    ON public.original_songs;
DROP POLICY IF EXISTS "original_songs_read"   ON public.original_songs;
DROP POLICY IF EXISTS "original_songs_insert" ON public.original_songs;
DROP POLICY IF EXISTS "original_songs_update" ON public.original_songs;
DROP POLICY IF EXISTS "original_songs_delete" ON public.original_songs;
CREATE POLICY "original_songs_read"   ON public.original_songs FOR SELECT USING (true);
CREATE POLICY "original_songs_insert" ON public.original_songs FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "original_songs_update" ON public.original_songs FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "original_songs_delete" ON public.original_songs FOR DELETE TO authenticated USING (true);

-- dress_items
ALTER TABLE public.dress_items ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "dress_all"          ON public.dress_items;
DROP POLICY IF EXISTS "dress_items_read"   ON public.dress_items;
DROP POLICY IF EXISTS "dress_items_insert" ON public.dress_items;
DROP POLICY IF EXISTS "dress_items_update" ON public.dress_items;
DROP POLICY IF EXISTS "dress_items_delete" ON public.dress_items;
CREATE POLICY "dress_items_read"   ON public.dress_items FOR SELECT USING (true);
CREATE POLICY "dress_items_insert" ON public.dress_items FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "dress_items_update" ON public.dress_items FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "dress_items_delete" ON public.dress_items FOR DELETE TO authenticated USING (true);

-- overlay_state (OBS 오버레이가 anon 으로 읽는다)
ALTER TABLE public.overlay_state ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "overlay_all"           ON public.overlay_state;
DROP POLICY IF EXISTS "overlay_state_read"    ON public.overlay_state;
DROP POLICY IF EXISTS "overlay_state_insert"  ON public.overlay_state;
DROP POLICY IF EXISTS "overlay_state_update"  ON public.overlay_state;
DROP POLICY IF EXISTS "overlay_state_delete"  ON public.overlay_state;
CREATE POLICY "overlay_state_read"   ON public.overlay_state FOR SELECT USING (true);
CREATE POLICY "overlay_state_insert" ON public.overlay_state FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "overlay_state_update" ON public.overlay_state FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "overlay_state_delete" ON public.overlay_state FOR DELETE TO authenticated USING (true);

-- inquiries — 보내기는 누구나, 읽기·삭제는 관리자만
ALTER TABLE public.inquiries ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "inquiries_all"    ON public.inquiries;
DROP POLICY IF EXISTS "inquiries_read"   ON public.inquiries;
DROP POLICY IF EXISTS "inquiries_insert" ON public.inquiries;
DROP POLICY IF EXISTS "inquiries_update" ON public.inquiries;
DROP POLICY IF EXISTS "inquiries_delete" ON public.inquiries;
CREATE POLICY "inquiries_insert" ON public.inquiries FOR INSERT TO anon, authenticated WITH CHECK (true);
CREATE POLICY "inquiries_read"   ON public.inquiries FOR SELECT TO authenticated USING (true);
CREATE POLICY "inquiries_update" ON public.inquiries FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "inquiries_delete" ON public.inquiries FOR DELETE TO authenticated USING (true);
