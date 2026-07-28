# 야옴 YAOM OFFICIAL — NIGHT DIAGONAL

바닐라 HTML/CSS/JS + Supabase + Cloudflare Pages. 빌드 과정 없음.

---

## 1. 폴더 구조

```
index.html            메인
style.css             전 페이지 공통 스타일
fx.js                 공통 동작 (별밭·페이지 전환·문의 모달·D-Day)
supabase.js           DB 연결 + 공통 함수
supabase_setup.sql    표 생성 + 기본 데이터
security_policy.sql           RLS 권한 설정
assets/               배경 이미지
profile/ schedule/ song/ notice/ dress/   공개 페이지
admin/                관리자 (Supabase Auth 로그인)
overlay/              OBS 오버레이
.github/workflows/    Supabase 킵얼라이브
```

---

## 2. 배포 순서

순서를 지킬 것. 정책부터 걸고 계정을 만들지 않으면 관리자가 로그인할 수 없다.

### ① 관리자 계정 생성
Supabase → Authentication → Users → Add user
- 이메일 / 비밀번호 입력, **Auto Confirm User 켜기**
- 이 계정으로 `admin/` 에 로그인한다. 비밀번호는 코드 어디에도 저장되지 않는다
- 비밀번호 변경·관리자 추가/삭제는 전부 이 화면에서 처리

### ② 표 생성
SQL Editor 에 `supabase_setup.sql` 전체 붙여넣고 Run

### ③ 권한 설정
SQL Editor 에 `security_policy.sql` 전체 붙여넣고 Run
- 읽기는 공개, 쓰기는 로그인한 관리자만
- 문의(`inquiries`)는 보내기만 공개, **읽기는 관리자 전용**
- 이 파일을 실행해야 사이트가 데이터를 읽을 수 있다

### ④ 연결 키
현재 프로젝트의 Project URL / anon public 키는 이미 입력되어 있다.
프로젝트를 새로 만들 때만 두 곳을 고친다.
- `supabase.js` 상단 두 줄
- `overlay/index.html` 의 `createClient` 줄 (오버레이는 자체 연결을 쓴다)

anon 키는 공개되어도 되는 키다. 권한은 ③의 정책이 담당한다.

### ⑤ 배포
GitHub 업로드 → Cloudflare Pages → Connect to Git → Framework preset **None**, 빌드 명령·출력 폴더 비움 → Deploy

### ⑥ SOOP 게시글 삽입
```html
<iframe height="2400" scrolling="no" src="배포주소" style="width:100%;border:0;display:block;"></iframe>
```
메인 높이는 iframe 높이와 무관하게 `가로폭 × 0.5625`(16:9)로 고정된다. 남는 아래 공간은 배경으로 비워진다.
- 메인만 맞추려면 `height = 게시글 가로폭 × 0.56` (가로 1000 → 560)
- 서브 페이지까지 스크롤 없이 보이게 하려면 2400
- 820px 이하에서는 세로형 비율로 전환되고, 상단 메뉴는 가로 스크롤 띠가 된다

### ⑦ 킵얼라이브 (선택)
GitHub → Settings → Secrets and variables → Actions 에 `SUPABASE_URL`, `SUPABASE_ANON_KEY` 등록.
월·목 09:00(KST)에 자동으로 요청을 보내 프로젝트 일시정지를 막는다.

---

## 3. 관리자

`배포주소/admin/` — ①에서 만든 이메일·비밀번호로 로그인. 세션은 새로고침해도 유지되며, 헤더의 로그아웃 버튼으로 종료한다.

| 탭 | 내용 |
|---|---|
| 메인 | 프사, 히어로 문구, ON AIR, 방송 요일, 링크 |
| 프로필 | 신원·방송 신호·한마디·능력치·좋아싫어·TMI·목표·VOD |
| 공지 | 공지 등록/삭제 |
| 일정 | 달력 일정 등록 (1·2부, 색상, 하이라이트) |
| 노래 | 노래책 곡 등록, 지금 트는 노래(OBS) 제어 |
| 옷장 | 착장 등록, 새 옷/기존 전환, 순서 변경 |
| 문의 | 받은 문의 확인 |
| 테마 | 색 6종 팔레트 (전 페이지 동시 적용) |

---

## 4. 입력 규격

| 항목 | 규격 |
|---|---|
| 프사 | SOOP 아이디 입력 시 자동 연동. 이미지 URL 입력 시 그쪽 우선 |
| 생일 | `MM.DD` (예: 07.28). D-Day 자동 계산 |
| 방송 요일 | 체크 = ON AIR, 해제 = OFF. 값은 0=월 ~ 6=일 |
| 옷장 이미지 | 세로 3:4 (900×1200) 권장 |
| 이미지 링크 | SOOP 비공개 게시판 업로드 후 이미지 주소 복사. 게시글 주소는 사용 불가. 원본 글 삭제 시 링크가 끊긴다 |
| VOD | `vod.sooplive.com/player/숫자` 의 숫자만 입력 |
| 반영 확인 | 저장 후 페이지에서 `Ctrl+Shift+R` |

---

## 5. 수정 시 주의

- 색은 `style.css` 의 `:root` 변수만 고치면 전 페이지에 반영된다. admin 테마 탭 저장값이 이 변수를 덮어쓴다
- 옷장 분류(`hair`/`outfit`/`lens`)를 바꿀 땐 세 곳을 함께 수정: `dress/index.html` 의 `CATS`, admin 의 `<select id="dr-cat">`, admin 의 `DRESS_CATS`
- 노래 장르를 바꿀 땐 `song/index.html` 의 `GENRES` 와 admin 의 `<select id="sg-genre">` 를 함께 수정
- 스크립트 로드 순서: `supabase.js` → 페이지 스크립트 → `fx.js`
- 한글에는 아웃라인(`-webkit-text-stroke`)을 쓰지 않는다. 아웃라인은 영문 전용
- 배경 이미지 교체 시 `assets/midnight-street.jpg`(메인), `assets/night-bg.jpg`(서브, 미리 블러 처리)를 같은 파일명으로 덮어쓴다
