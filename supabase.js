/* 프로젝트를 새로 만들면 아래 두 줄을 교체한다.
   overlay/index.html 은 자체 createClient 를 쓰므로 그쪽도 같이 고칠 것 */

const SUPABASE_URL  = 'https://bcdjxstzvrqghlfvqqkk.supabase.co';
const SUPABASE_ANON = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJjZGp4c3R6dnJxZ2hsZnZxcWtrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODUxODA2NTAsImV4cCI6MjEwMDc1NjY1MH0.jx1VnbvGCAlmYBaPxc090aTuDzYXjwtgs3VptVn9SwM';

const { createClient } = supabase;
const db = createClient(SUPABASE_URL, SUPABASE_ANON);

/* CRUD 헬퍼 */
async function fetchAll(table, options = {}) {
  let query = db.from(table).select('*');
  if (options.order)  query = query.order(options.order, { ascending: options.asc ?? false });
  if (options.limit)  query = query.limit(options.limit);
  if (options.filter) query = query.eq(options.filter.col, options.filter.val);
  const { data, error } = await query;
  if (error) { console.error(`fetchAll(${table}) 오류:`, error); return []; }
  return data;
}
async function insertRow(table, row) {
  const { error } = await db.from(table).insert(row);
  if (error) { console.error(`insertRow(${table}) 오류:`, error); return false; }
  return true;
}
async function deleteRow(table, id) {
  const { error } = await db.from(table).delete().eq('id', id);
  if (error) { console.error(`deleteRow(${table}) 오류:`, error); return false; }
  return true;
}
async function updateRow(table, id, updates) {
  const { error } = await db.from(table).update(updates).eq('id', id);
  if (error) { console.error(`updateRow(${table}) 오류:`, error); return false; }
  return true;
}

/* profile 은 id=1 한 행의 data(JSON) 한 칸을 통째로 읽고 쓴다 */
async function loadProfile() {
  try {
    const { data: rows } = await db.from('profile').select('data').eq('id', 1);
    if (rows && rows.length && rows[0].data) return rows[0].data;
  } catch (e) { console.error('loadProfile 오류:', e); }
  return {};
}
/* SOOP 아이디 -> 프사 주소 */
function soopAvatarUrl(id) {
  id = (id || '').trim().toLowerCase();
  if (id.length < 2) return '';
  return `https://profile.img.sooplive.co.kr/LOGO/${id.slice(0,2)}/${id}/${id}.jpg`;
}

/* 토스트 */
function showToast(msg, duration = 2500) {
  let t = document.getElementById('toast');
  if (!t) { t = document.createElement('div'); t.id = 'toast'; t.className = 'toast'; document.body.appendChild(t); }
  t.textContent = msg;
  t.classList.add('show');
  setTimeout(() => t.classList.remove('show'), duration);
}

/* iframe 자동 높이 (SOOP 게시글 삽입용) */
function initIframeResize() {
  const send = () => window.parent.postMessage({ type: 'resize', height: document.body.scrollHeight }, '*');
  send();
  new ResizeObserver(send).observe(document.body);
}
function enableIframeAutoHeight() { initIframeResize(); }

/* admin 테마 탭 저장값을 CSS 변수로 적용. 키를 바꾸면 admin PAL_MAP 도 같이 고칠 것
   theme-main       → --cyan       (액센트)
   theme-main-dark  → --cyan-dim   (보조 액센트)
   theme-main-deep  → --cyan-deep  (진한 액센트)
   theme-main-light → --line       (1px 라인 색)
   theme-bg         → --night      (배경)
   theme-logo       → --logo       (로고 글자)
   */
async function applyTheme(){
  try{
    const { data } = await db.from('profile').select('data').eq('id',1).single();
    const p = (data && data.data) || {};
    const map = {
      'theme-main':      '--cyan',
      'theme-main-dark': '--cyan-dim',
      'theme-main-deep': '--cyan-deep',
      'theme-main-light':'--line',
      'theme-bg':        '--night',
      'theme-logo':      '--logo'
    };
    Object.keys(map).forEach(function(k){
      if(p[k]) document.documentElement.style.setProperty(map[k], p[k]);
    });
  }catch(e){ }
}
applyTheme();
