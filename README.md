# 야옴 YAOM OFFICIAL — NIGHT DIAGONAL

메인 12번 시안(NIGHT DIAGONAL)을 기준으로 전 페이지를 맞춘 사이트예요.
바닐라 HTML/CSS/JS + Supabase + Cloudflare Pages 조합이라 빌드 과정이 없어요.

---

## 1. 폴더 구조

```
index.html            메인 (NIGHT DIAGONAL)
style.css             전 페이지 공통 스타일 (색·레이아웃)
fx.js                 공통 연출 (별밭·클릭 ✦·페이지 전환·문의 모달·D-Day)
supabase.js           DB 연결 + 공통 함수  ← ⚠️ 여기 두 줄만 채우면 됨
supabase_setup.sql    Supabase에 한 번 붙여넣고 Run
assets/               배경 이미지 (midnight-street.jpg / night-bg.jpg)
profile/              프로필
schedule/             방송 일정 (달력)
song/                 노래책 (SETLIST)
notice/               공지
dress/                옷장 (WARDROBE)
admin/                관리자 페이지
overlay/              OBS "지금 트는 노래" 오버레이
.github/workflows/    Supabase 킵얼라이브 (월·목 자동 핑)
```

---

## 2. 셋업 순서

### ① Supabase
1. New project 생성 → **Settings → API** 에서 `Project URL`, `anon public` 키 복사
2. **SQL Editor** 에 `supabase_setup.sql` 전체를 붙여넣고 **Run**
   - 표 생성 + 야옴 기본 프로필 데이터 + 시그니처 VOD가 한 번에 들어가요
   - 여러 번 다시 실행해도 저장된 내용은 지워지지 않아요

### ② Supabase 키 — ✅ 이미 입력되어 있어요
`supabase.js` 상단 두 줄과 `overlay/index.html` 안의 연결 줄에
프로젝트 `bcdjxstzvrqghlfvqqkk` + anon 키가 이미 채워져 있어요. 그대로 쓰면 됩니다.
(나중에 프로젝트를 바꾸면 이 **두 파일**을 같이 고쳐야 해요 — 오버레이는 자체 연결을 씁니다.)

### ③ GitHub → Cloudflare Pages
1. 이 폴더 구조 그대로 GitHub 저장소에 업로드
2. Cloudflare Pages → Connect to Git → 저장소 선택
3. **Framework preset = None**, 빌드 명령/출력 폴더 비움 → Deploy

### ④ SOOP 게시글에 삽입
```html
<iframe height="2400" scrolling="no" src="배포주소" style="width:100%;border:0;display:block;"></iframe>
```

**메인 높이는 iframe 높이와 상관없이 "가로폭 × 0.5625"(16:9)로 고정돼요.**
높이를 2400으로 크게 줘도 메인이 늘어나지 않고, 남는 아래쪽은 별밤 배경으로 채워집니다.
- 메인만 딱 맞게 보이고 싶으면 → `height = 게시글 가로폭 × 0.56` (가로 1000이면 **560**)
- 서브 페이지(프로필·일정·노래책 등)까지 스크롤 없이 보이게 하려면 → **2400** 권장 (메인 아래 여백은 감수)
- 좁은 화면(820px 이하)에서는 세로형 비율로 자동 전환되고, 상단 카테고리 메뉴는 가로 스크롤 띠로 바뀝니다.

### ⑤ 킵얼라이브 (선택 · 권장)
GitHub 저장소 → Settings → Secrets and variables → Actions 에서
`SUPABASE_URL`, `SUPABASE_ANON_KEY` 두 개를 등록하면 월·목마다 자동으로 핑을 보내요.

---

## 3. 관리자 페이지

`배포주소/admin/` · 임시 비밀번호 **`1234`**

> ⚠️ **배포 전에 반드시 바꿔주세요.** `admin/index.html` 안의
> `const ADMIN_PASSWORD = '1234';` 한 줄이에요. 소스에 그대로 보이니
> 다른 곳에서 쓰지 않는 **버리는 비밀번호**로 정해주세요.

| 탭 | 하는 일 |
|---|---|
| 🏠 메인 | 프사, 히어로 문구, ON AIR, 방송 요일, 링크 |
| 🎀 프로필 | 신원·방송 신호·한마디·능력치·좋아싫어·TMI·목표·VOD |
| 📢 공지 | 공지 등록/삭제 (이미지 링크 여러 장 가능) |
| 📅 일정 | 달력 일정 등록 (1·2부, 색상, 하이라이트) |
| 🎵 노래 | 노래책 곡 등록 + **지금 트는 노래(OBS)** 제어 |
| 👗 옷장 | 착장 등록, 새 옷/기존 전환, 순서 변경 |
| ✉️ 문의 | 사이트에서 들어온 익명 신호 확인 |
| 🎨 테마 | 색 6종 팔레트 — 저장하면 전 페이지에 한 번에 적용 |

---

## 4. 자주 쓰는 규격

- **프사** — 관리자 🏠메인 탭에 SOOP 아이디(`yaom0728`)만 넣으면 자동. 직접 이미지 URL을 넣으면 그게 우선.
- **생일** — `MM.DD` (예: `07.28`) → 메인·프로필 D-Day 자동 계산
- **옷장 사진** — 세로 **3:4 (900×1200 권장)**
- **공지/옷장 이미지** — SOOP 비공개 게시판에 올린 뒤 사진 **우클릭 → 이미지 주소 복사**
  (게시글 주소 ✗ / 원본 글을 지우면 이미지가 깨져요)
- **VOD** — `vod.sooplive.com/player/**181755081**` 에서 숫자만 입력
- **저장했는데 안 보이면** — 페이지에서 `Ctrl+Shift+R` (강력 새로고침)

---

## 5. 디자인 메모

- **컨셉**: 심야 도시의 네온 대각선 — 야옴이 밤에 켜는 채널
- **규칙**: 둥근 모서리 없음(radius 0) · 1px 시안 라인 · -13° 대각선 모티프
- **색**: 액센트 `#22D9FF` / 배경 `#030815` — 관리자 🎨테마 탭에서 전 페이지 동시 변경 가능
- **DAY 모드**: 상단 `☾ NIGHT / ☀ DAY` 토글 (선택은 브라우저에 저장돼 페이지를 옮겨도 유지)
- **페이지 번호**: 메인 → 02 PROFILE / 03 SCHEDULE / 04 SETLIST / 05 NOTICE / 06 WARDROBE

배경 이미지를 바꾸려면 `assets/midnight-street.jpg`(메인)와
`assets/night-bg.jpg`(서브 페이지 · 미리 흐리게 처리된 버전)를 같은 파일명으로 덮어쓰면 돼요.
