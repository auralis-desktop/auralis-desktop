// Auralis website scripts

// ── Theme toggle ──────────────────────────────────────────────────────────────
const root   = document.documentElement;
const toggle = document.getElementById('themeToggle');
const icon   = toggle?.querySelector('.material-symbols-outlined');

function getTheme() {
  return localStorage.getItem('theme') ||
    (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
}

function applyTheme(t) {
  root.setAttribute('data-theme', t);
  if (icon) icon.textContent = t === 'dark' ? 'dark_mode' : 'light_mode';
  localStorage.setItem('theme', t);
}

applyTheme(getTheme());

toggle?.addEventListener('click', () => {
  applyTheme(root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark');
});

// ── Nav scroll style ──────────────────────────────────────────────────────────
const nav = document.getElementById('nav');
window.addEventListener('scroll', () => {
  nav?.classList.toggle('scrolled', window.scrollY > 24);
}, { passive: true });

// ── Copy install command ──────────────────────────────────────────────────────
function copyInstall(btn) {
  const code = btn.closest('.code-block')?.querySelector('code');
  if (!code) return;

  navigator.clipboard.writeText(code.textContent).then(() => {
    const i = btn.querySelector('.material-symbols-outlined');
    if (!i) return;
    i.textContent = 'check';
    btn.style.color = '#86EFAC';
    setTimeout(() => {
      i.textContent = 'content_copy';
      btn.style.color = '';
    }, 2000);
  });
}

window.copyInstall = copyInstall;

// ── Custom cursor follower ────────────────────────────────────────────────────
// Skip on touch / coarse-pointer devices (phones, tablets)
if (window.matchMedia('(pointer: fine)').matches) {
  // Inject cursor elements
  const cursorCSS = `
    #cur-dot, #cur-ring {
      position: fixed; top: 0; left: 0;
      border-radius: 50%;
      pointer-events: none;
      z-index: 99999;
      will-change: transform;
      transition: opacity 300ms;
    }
    #cur-dot {
      width: 8px; height: 8px;
      background: var(--md-primary, #7965D9);
      transform: translate(-50%, -50%);
      transition: width 200ms cubic-bezier(0.2,0,0,1),
                  height 200ms cubic-bezier(0.2,0,0,1),
                  background 200ms, opacity 300ms;
    }
    #cur-ring {
      width: 36px; height: 36px;
      border: 2px solid var(--md-primary, #7965D9);
      opacity: 0.45;
      transform: translate(-50%, -50%);
      transition: width 350ms cubic-bezier(0.2,0,0,1),
                  height 350ms cubic-bezier(0.2,0,0,1),
                  border-color 200ms, opacity 300ms;
    }
    /* Grow ring + shrink dot on hover */
    body.cur-hover #cur-dot  { width: 6px; height: 6px; opacity: 0.6; }
    body.cur-hover #cur-ring { width: 56px; height: 56px; opacity: 0.25; }
    /* Squish on click */
    body.cur-click #cur-dot  { width: 12px; height: 12px; }
    body.cur-click #cur-ring { width: 28px; height: 28px; opacity: 0.7; }
    /* Hide native cursor site-wide */
    body { cursor: none !important; }
    a, button, [role="button"], input, label, select, textarea {
      cursor: none !important;
    }
  `;
  const styleEl = document.createElement('style');
  styleEl.textContent = cursorCSS;
  document.head.appendChild(styleEl);

  const dot  = document.createElement('div'); dot.id  = 'cur-dot';
  const ring = document.createElement('div'); ring.id = 'cur-ring';
  document.body.appendChild(dot);
  document.body.appendChild(ring);

  // Mouse state
  let mx = -100, my = -100;   // raw mouse
  let rx = -100, ry = -100;   // ring (lagging)
  let rafId = null;

  // Update raw position instantly (dot snaps)
  document.addEventListener('mousemove', e => {
    mx = e.clientX; my = e.clientY;
    dot.style.transform = `translate(calc(${mx}px - 50%), calc(${my}px - 50%))`;
  });

  // Ring follows with spring lag
  function lerp(a, b, t) { return a + (b - a) * t; }
  function tick() {
    rx = lerp(rx, mx, 0.12);
    ry = lerp(ry, my, 0.12);
    ring.style.transform = `translate(calc(${rx}px - 50%), calc(${ry}px - 50%))`;
    rafId = requestAnimationFrame(tick);
  }
  tick();

  // Hover state: enlarge ring on interactive elements
  const hoverSel = 'a, button, [role="button"], input, label, select, .btn, .feature-card, .nav-brand';
  document.addEventListener('mouseover', e => {
    if (e.target.closest(hoverSel)) document.body.classList.add('cur-hover');
  });
  document.addEventListener('mouseout', e => {
    if (e.target.closest(hoverSel)) document.body.classList.remove('cur-hover');
  });

  // Click pulse
  document.addEventListener('mousedown', () => {
    document.body.classList.add('cur-click');
  });
  document.addEventListener('mouseup', () => {
    document.body.classList.remove('cur-click');
  });

  // Hide when mouse leaves window
  document.addEventListener('mouseleave', () => {
    dot.style.opacity  = '0';
    ring.style.opacity = '0';
  });
  document.addEventListener('mouseenter', () => {
    dot.style.opacity  = '';
    ring.style.opacity = '';
  });

  // Re-tint when theme changes
  function syncCursorColor() {
    const col = getComputedStyle(document.documentElement)
                  .getPropertyValue('--md-primary').trim() || '#7965D9';
    dot.style.background  = col;
    ring.style.borderColor = col;
  }
  const themeObs = new MutationObserver(syncCursorColor);
  themeObs.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });
  syncCursorColor();
}

// ── Animate cards on scroll ───────────────────────────────────────────────────
if ('IntersectionObserver' in window) {
  const cards = document.querySelectorAll('.feature-card');
  cards.forEach((c, i) => {
    c.style.opacity    = '0';
    c.style.transform  = 'translateY(20px)';
    c.style.transition = `opacity 400ms ${i * 40}ms, transform 400ms ${i * 40}ms cubic-bezier(0.2,0,0,1)`;
  });

  const observer = new IntersectionObserver(entries => {
    entries.forEach(e => {
      if (e.isIntersecting) {
        e.target.style.opacity   = '1';
        e.target.style.transform = 'translateY(0)';
        observer.unobserve(e.target);
      }
    });
  }, { threshold: 0.1 });

  cards.forEach(c => observer.observe(c));
}
