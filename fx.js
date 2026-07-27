/* ============================================================
   야옴 YAOM — fx.js (NIGHT DIAGONAL 공통 연출·동작)
   별밭 · 클릭 ✦ 팝 · 페이지 전환(TUNING…) · SEND SIGNAL 문의 모달 ·
   D-Day · 스크롤 리빌 · FOUC 게이트 · DAY/NIGHT 모드 · 라이트박스
   ⚠ supabase.js 뒤에 로드할 것 (문의 전송에 insertRow 사용)
   ── 새 사람에게 옮길 때 교체 지점 ──
   FX_BIRTH(생일 MM-DD) / FX_DEBUT(데뷔 YYYY-MM-DD) / FX_MARK(입자 모양)
   ============================================================ */
var FX_BIRTH = '07-28';
var FX_DEBUT = '2024-02-10';
var FX_MARK  = '✦';

(function(){
  var $  = function(s){ return document.querySelector(s); };
  var $$ = function(s){ return Array.prototype.slice.call(document.querySelectorAll(s)); };
  var FX = window.FX = {};
  var noMotion = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  /* ---------- DAY / NIGHT 모드 ---------- */
  function syncMode(){
    var day = document.body.classList.contains('day');
    $$('[data-mode]').forEach(function(b){ b.textContent = day ? '☀ DAY' : '☾ NIGHT'; });
  }
  FX.syncMode = syncMode;
  document.addEventListener('click', function(e){
    var b = e.target.closest('[data-mode]');
    if(!b) return;
    document.body.classList.toggle('day');
    try{ localStorage.setItem('yaom-mode', document.body.classList.contains('day') ? 'day' : 'night'); }catch(err){}
    syncMode();
  });
  syncMode();

  /* ---------- 공통 레이어 자동 주입 ---------- */
  function el(tag, id, html){
    var n = document.getElementById(id);
    if(n) return n;
    n = document.createElement(tag);
    n.id = id;
    if(html) n.innerHTML = html;
    document.body.appendChild(n);
    return n;
  }
  var stars = el('div','sgStars');
  el('div','sgFx');
  var cover = el('div','sgCover','<div class="in"><i></i>TUNING…</div>');

  /* 문의(SEND SIGNAL) 모달 — admin 제외 전 페이지 */
  if(!document.body.hasAttribute('data-noask')){
    el('div','askMask');
    el('div','askBox',
      '<div class="frm">'+
        '<div class="sk"><i></i>SEND SIGNAL</div>'+
        '<h3>야옴에게 신호 보내기</h3>'+
        '<p class="sub">하고 싶은 말·문의를 남겨주세요. 익명으로 야옴에게만 전달돼요.</p>'+
        '<textarea class="input" id="askTa" placeholder="보내고 싶은 말을 적어주세요…"></textarea>'+
        '<div class="row"><button class="btn" id="askNo">CANCEL</button><button class="btn hi" id="askGo">TRANSMIT ↗</button></div>'+
      '</div>'+
      '<div class="done"><div class="st">✦</div><b>신호 전송 완료</b><span>잘 받았어요 — 고마워요, 꽁냥이!</span></div>');
    el('div','lbox','<button class="x" onclick="FX.closeLb()">CLOSE ✕</button><div class="in"><img id="lbImg" alt=""><div class="cap" id="lbCap"></div></div>');
  }

  /* ---------- 별밭 ---------- */
  if(stars && !stars.childNodes.length && !noMotion){
    for(var i=0;i<34;i++){
      var st = document.createElement('i');
      var z = Math.random();
      st.style.left = (Math.random()*100)+'%';
      st.style.top  = (Math.random()*100)+'%';
      st.style.width = st.style.height = (z*2+0.8)+'px';
      st.style.animationDuration = (2.6+Math.random()*3)+'s';
      st.style.animationDelay = (Math.random()*3)+'s';
      stars.appendChild(st);
    }
  }

  /* ---------- 클릭 ✦ 팝 ---------- */
  function pop(x,y,n){
    var fx = document.getElementById('sgFx');
    if(!fx || noMotion) return;
    for(var i=0;i<(n||1);i++){
      var p = document.createElement('span');
      p.className = 'sg-pop';
      p.textContent = FX_MARK;
      p.style.left = (x + (Math.random()*28-14)) + 'px';
      p.style.top  = (y + (Math.random()*12-6))  + 'px';
      fx.appendChild(p);
      (function(q){ setTimeout(function(){ q.remove(); }, 900); })(p);
    }
  }
  FX.pop = pop;
  document.addEventListener('click', function(e){
    if(e.target.closest('button, a, input, textarea, select, #askBox, #lbox')) return;
    pop(e.clientX, e.clientY, 1);
  });

  /* ---------- 페이지 전환 커버 ---------- */
  document.addEventListener('click', function(e){
    var a = e.target.closest('a[href]');
    if(!a || noMotion) return;
    var href = a.getAttribute('href');
    if(!href || a.target === '_blank' || href.charAt(0) === '#') return;
    if(/^(https?:|mailto:|tel:)/i.test(href)) return;
    e.preventDefault();
    cover.classList.add('on');
    setTimeout(function(){ location.href = href; }, 230);
  });

  /* ---------- D-Day ---------- */
  FX.dday = function(md){
    var p = md.split('-'), n = new Date();
    var today = new Date(n.getFullYear(), n.getMonth(), n.getDate());
    var t = new Date(n.getFullYear(), +p[0]-1, +p[1]);
    if(t < today) t = new Date(n.getFullYear()+1, +p[0]-1, +p[1]);
    return Math.round((t - today) / 864e5);
  };
  FX.dplus = function(iso){
    var p = iso.split('-'), s = new Date(+p[0], +p[1]-1, +p[2]);
    var n = new Date(), today = new Date(n.getFullYear(), n.getMonth(), n.getDate());
    return Math.floor((today - s) / 864e5);
  };
  FX.paintDday = function(birth, debut){
    var bd = FX.dday(birth || FX_BIRTH);
    var dp = FX.dplus(debut || FX_DEBUT);
    $$('[data-dday]').forEach(function(e){ e.textContent = (bd === 0 ? 'TODAY ✦' : 'D-' + bd); });
    $$('[data-debut]').forEach(function(e){ e.textContent = 'D+' + dp; });
  };
  FX.paintDday();

  /* ---------- SEND SIGNAL 모달 ---------- */
  var mask = document.getElementById('askMask'), box = document.getElementById('askBox');
  FX.openAsk = function(){
    if(!box) return;
    box.classList.remove('ok'); mask.classList.add('on'); box.classList.add('on');
    var t = document.getElementById('askTa'); if(t) t.value = '';
  };
  FX.closeAsk = function(){ if(!box) return; mask.classList.remove('on'); box.classList.remove('on'); };
  if(box){
    document.addEventListener('click', function(e){
      if(e.target.closest('[data-ask]')) FX.openAsk();
      if(e.target === mask || e.target.id === 'askNo') FX.closeAsk();
    });
    var go = document.getElementById('askGo');
    if(go) go.addEventListener('click', function(){
      var t = document.getElementById('askTa'), v = (t && t.value || '').trim();
      if(!v){ alert('내용을 입력해 주세요!'); return; }
      if(typeof insertRow !== 'function'){ alert('아직 서버 연결 전이에요 — Supabase 키 입력 후 전송돼요.'); return; }
      go.disabled = true;
      insertRow('inquiries', { message: v }).then(function(ok){
        go.disabled = false;
        if(ok){ box.classList.add('ok'); setTimeout(FX.closeAsk, 1600); }
        else alert('전송에 실패했어요. 잠시 후 다시 시도해 주세요.');
      });
    });
    document.addEventListener('keydown', function(e){ if(e.key === 'Escape'){ FX.closeAsk(); FX.closeLb(); } });
  }

  /* ---------- 라이트박스 ---------- */
  FX.openLb = function(src, name, desc){
    var b = document.getElementById('lbox'); if(!b || !src) return;
    document.getElementById('lbImg').src = src;
    document.getElementById('lbCap').innerHTML =
      (name ? String(name).replace(/</g,'&lt;') : '') + (desc ? '<span>' + String(desc).replace(/</g,'&lt;') + '</span>' : '');
    b.classList.add('on');
  };
  FX.closeLb = function(){ var b = document.getElementById('lbox'); if(b) b.classList.remove('on'); };
  var lb = document.getElementById('lbox');
  if(lb) lb.addEventListener('click', function(e){ if(e.target === lb) FX.closeLb(); });

  /* ---------- 스크롤 리빌 ---------- */
  FX.reveal = function(){
    var rvs = $$('.rv');
    if('IntersectionObserver' in window){
      var io = new IntersectionObserver(function(es){
        es.forEach(function(en){ if(en.isIntersecting){ en.target.classList.add('in'); io.unobserve(en.target); } });
      }, { threshold:.12 });
      rvs.forEach(function(el2){ if(!el2.classList.contains('in')) io.observe(el2); });
    } else rvs.forEach(function(el2){ el2.classList.add('in'); });
  };
  FX.reveal();

  /* ---------- FOUC 게이트 ---------- */
  FX.ready = function(){
    document.body.classList.add('ready');
    $$('.rv').forEach(function(e){
      var r = e.getBoundingClientRect();
      if(r.top < window.innerHeight * 0.92) e.classList.add('in');
    });
  };
  if(document.readyState === 'complete') FX.ready();
  else window.addEventListener('load', FX.ready);
  setTimeout(FX.ready, 1600);
})();
