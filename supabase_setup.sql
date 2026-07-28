-- =============================================================
-- YAOM OFFICIAL — 표 생성 + 기본 데이터
-- 실행 순서: ① Authentication > Users 에서 관리자 계정 생성
--            ② 이 파일 실행
--            ③ 보안정책.sql 실행  (이걸 실행해야 읽기/쓰기 권한이 열린다)
-- 여러 번 다시 실행해도 저장된 데이터는 지워지지 않는다.
-- 이미지는 전부 링크 방식이라 Storage 설정이 필요 없다.
-- =============================================================

-- profile: id=1 한 행의 JSON 한 칸에 모든 프로필 값이 들어간다
CREATE TABLE IF NOT EXISTS profile (
  id         BIGINT PRIMARY KEY,
  data       JSONB NOT NULL DEFAULT '{}'::jsonb,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE profile ENABLE ROW LEVEL SECURITY;

-- notice
CREATE TABLE IF NOT EXISTS notice (
  id         BIGSERIAL PRIMARY KEY,
  title      TEXT NOT NULL,
  content    TEXT,
  pinned     BOOLEAN DEFAULT FALSE,
  image_url  TEXT,
  images     JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE notice ADD COLUMN IF NOT EXISTS image_url TEXT;
ALTER TABLE notice ADD COLUMN IF NOT EXISTS images JSONB DEFAULT '[]'::jsonb;
ALTER TABLE notice ENABLE ROW LEVEL SECURITY;

-- schedule
CREATE TABLE IF NOT EXISTS schedule (
  id          BIGSERIAL PRIMARY KEY,
  title       TEXT NOT NULL,
  date        DATE NOT NULL,
  time        TEXT,
  type        TEXT DEFAULT '방송',
  note        TEXT,
  color       TEXT DEFAULT 'green',
  highlight   BOOLEAN DEFAULT FALSE,
  time2       TEXT,
  title2      TEXT,
  type2       TEXT,
  description TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE schedule ADD COLUMN IF NOT EXISTS color       TEXT DEFAULT 'green';
ALTER TABLE schedule ADD COLUMN IF NOT EXISTS highlight   BOOLEAN DEFAULT FALSE;
ALTER TABLE schedule ADD COLUMN IF NOT EXISTS time2       TEXT;
ALTER TABLE schedule ADD COLUMN IF NOT EXISTS title2      TEXT;
ALTER TABLE schedule ADD COLUMN IF NOT EXISTS type2       TEXT;
ALTER TABLE schedule ADD COLUMN IF NOT EXISTS description TEXT;
ALTER TABLE schedule ENABLE ROW LEVEL SECURITY;

-- songs
CREATE TABLE IF NOT EXISTS songs (
  id         BIGSERIAL PRIMARY KEY,
  title      TEXT NOT NULL,
  artist     TEXT,
  genre      TEXT DEFAULT '기타',
  difficulty INT  DEFAULT 3,
  memo       TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE songs ENABLE ROW LEVEL SECURITY;

-- original_songs (SOOP VOD)
CREATE TABLE IF NOT EXISTS original_songs (
  id         BIGSERIAL PRIMARY KEY,
  title      TEXT NOT NULL,
  vod_id     TEXT,
  thumbnail  TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE original_songs ENABLE ROW LEVEL SECURITY;

-- dress_items (분류 값 hair/outfit/lens 는 dress/index.html CATS, admin select, admin DRESS_CATS 와 같아야 함)
CREATE TABLE IF NOT EXISTS public.dress_items (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category    TEXT NOT NULL DEFAULT 'hair',
  name        TEXT NOT NULL,
  description TEXT DEFAULT '',
  image_key   TEXT DEFAULT '',
  image_url   TEXT DEFAULT '',
  badges      JSONB DEFAULT '[]',
  is_event    BOOLEAN DEFAULT FALSE,
  glow_color  TEXT DEFAULT '',
  sort_order  INT DEFAULT 0,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_dress_items_category ON public.dress_items(category);
ALTER TABLE public.dress_items ENABLE ROW LEVEL SECURITY;

-- inquiries
CREATE TABLE IF NOT EXISTS inquiries (
  id         BIGSERIAL PRIMARY KEY,
  nickname   TEXT,
  message    TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- overlay_state: 항상 id=1 한 행만 사용
CREATE TABLE IF NOT EXISTS public.overlay_state (
  id          INT PRIMARY KEY DEFAULT 1 CHECK (id = 1),
  song_title  TEXT DEFAULT '',
  song_artist TEXT DEFAULT '',
  is_visible  BOOLEAN DEFAULT FALSE,
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);
INSERT INTO public.overlay_state (id) VALUES (1) ON CONFLICT (id) DO NOTHING;
ALTER TABLE public.overlay_state ENABLE ROW LEVEL SECURITY;


-- 기본 프로필 데이터 (profile 행이 없을 때만 입력됨)
-- 다른 사람 데이터가 남은 프로젝트를 재사용한다면 아래 DELETE 주석을 풀고 한 번 실행한 뒤 다시 Run
-- DELETE FROM profile WHERE id = 1;
INSERT INTO profile (id, data) VALUES (1, '{
  "avatar": "",
  "soop-id": "yaom0728",
  "info-name": "야옴",
  "info-en": "YAOM",
  "info-catchphrase": "아무래도 아무래도",
  "info-debut": "2024.02.10",
  "info-birth": "07.28",
  "info-gender": "여",
  "info-agency": "개인세",
  "info-fandom": "꽁냥이",
  "info-mbti": "미공개",
  "info-tags": "차분함, 밝음, 긍정적임, 친화력 만땅, 친절",
  "info-content": "게임 · 저챗 · 노래",
  "info-game": "리그오브레전드 · 배틀그라운드",
  "info-song": "어른아이",
  "info-genre": "발라드",
  "info-avoid": "해외 노래",
  "info-motif": "별 · 달 · 밤하늘",
  "main-kicker": "NIGHT CREATOR",
  "main-tagline": "아무래도 아무래도 · GAME · TALK · SONG",
  "on-air": "MON–SAT / 20:00",
  "on-air-kr": "월–토 / 저녁 8시",
  "on-air-note": "SOOP LIVE CHANNEL",
  "quote": "아무래도, 오늘 밤도 여기서 만나요.",
  "msg": "차분하고 밝은 톤으로 게임 · 저챗 · 노래를 오가는 야옴이에요.\n월요일부터 토요일 밤 8시, 별 보러 오듯 편하게 들러주세요.",
  "now": "",
  "like-list": "고양이, 소통, 회",
  "dislike-list": "다리 많은 벌레, 오이, 공포",
  "stats": "친화력:95\n텐션:80\n노래:85\n게임:75\n차분함:90",
  "milestones": "달성|첫 방송 2024.02.10\n진행 중|꽁냥이 팬카페 모으기\n준비 중|첫 커버곡 공개",
  "tmi-food": "회",
  "tmi-song": "어른아이",
  "tmi-book": "-",
  "days": "0,1,2,3,4,5",
  "link-soop": "https://www.sooplive.com/station/yaom0728",
  "link-youtube": "https://www.youtube.com/@yaom_0728",
  "link-cafe": "https://cafe.naver.com/vbbd",
  "link-x": "",
  "theme-main": "", "theme-main-dark": "", "theme-main-deep": "",
  "theme-main-light": "", "theme-bg": "", "theme-logo": ""
}'::jsonb) ON CONFLICT (id) DO NOTHING;

-- 시그니처 곡 VOD (없을 때만)
INSERT INTO original_songs (title, vod_id)
SELECT '어른아이', '181755081'
WHERE NOT EXISTS (SELECT 1 FROM original_songs WHERE vod_id = '181755081');
