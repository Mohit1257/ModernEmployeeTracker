/* ============================================================
   Employee Tracker — app.js v2
   Particles · Counter · Ripple · Scroll Reveal · Theme
   ============================================================ */

document.addEventListener('DOMContentLoaded', () => {
    initTheme();
    initSidebar();
    initToasts();
    initCounters();
    initScrollReveal();
    initRipple();
    initParticles();
    hideLoader();
    setActiveNav();
});

/* ── Page Loader ──────────────────────────────────────────── */
function hideLoader() {
    const loader = document.getElementById('pageLoader');
    if (!loader) return;
    setTimeout(() => {
        loader.style.opacity = '0';
        setTimeout(() => loader.remove(), 500);
    }, 300);
}

/* ── Theme ────────────────────────────────────────────────── */
function initTheme() {
    const saved = localStorage.getItem('theme') || 'dark';
    applyTheme(saved);
    document.getElementById('themeToggle')
        ?.addEventListener('click', () => {
            const cur  = document.documentElement.getAttribute('data-theme') || 'dark';
            const next = cur === 'dark' ? 'light' : 'dark';
            applyTheme(next);
            localStorage.setItem('theme', next);
        });
}
function applyTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
    const btn = document.getElementById('themeToggle');
    if (btn) {
        btn.innerHTML = theme === 'dark' ? '<i class="fas fa-sun"></i>' : '<i class="fas fa-moon"></i>';
        btn.title     = theme === 'dark' ? 'Switch to Light' : 'Switch to Dark';
    }
}

/* ── Sidebar ──────────────────────────────────────────────── */
function initSidebar() {
    const toggle  = document.getElementById('sidebarToggle');
    const sidebar = document.getElementById('sidebar');
    if (!toggle || !sidebar) return;
    toggle.addEventListener('click', () => {
        const open = sidebar.classList.toggle('open');
        ensureOverlay(open);
    });
}
function ensureOverlay(show) {
    let o = document.getElementById('sidebarOverlay');
    if (show) {
        if (!o) {
            o = document.createElement('div');
            o.id = 'sidebarOverlay';
            o.className = 'sidebar-overlay';
            document.body.appendChild(o);
            o.addEventListener('click', () => {
                document.getElementById('sidebar')?.classList.remove('open');
                o.remove();
            });
        }
    } else { o?.remove(); }
}

/* ── Active nav ──────────────────────────────────────────── */
function setActiveNav() {
    const path = window.location.pathname;
    document.querySelectorAll('.nav-item').forEach(link => {
        link.classList.remove('active');
        const href = link.getAttribute('href') || '';
        if (href === '/' ? path === '/' : (href && path.startsWith(href)))
            link.classList.add('active');
    });
}

/* ── Toasts ──────────────────────────────────────────────── */
function initToasts() {
    document.querySelectorAll('.toast').forEach(t => {
        setTimeout(() => dismissToast(t), 4500);
        t.querySelector('.toast-close')?.addEventListener('click', () => dismissToast(t));
        t.addEventListener('click', () => dismissToast(t));
    });
}
function dismissToast(toast) {
    toast.style.cssText += ';transition:all 0.35s ease;opacity:0;transform:translateX(60px)';
    setTimeout(() => toast.remove(), 360);
}

/* ── Animated Counters ───────────────────────────────────── */
function initCounters() {
    document.querySelectorAll('.stat-value[data-target]').forEach(el => {
        const target = parseInt(el.dataset.target, 10);
        if (isNaN(target)) return;
        const prefix = el.dataset.prefix || '';
        const suffix = el.dataset.suffix || '';
        let start = null;
        const dur = 1200;
        function step(ts) {
            if (!start) start = ts;
            const pct = Math.min((ts - start) / dur, 1);
            // Ease out expo
            const ease = pct === 1 ? 1 : 1 - Math.pow(2, -10 * pct);
            const val  = Math.floor(ease * target);
            el.textContent = prefix + val.toLocaleString() + suffix;
            if (pct < 1) requestAnimationFrame(step);
        }
        // Trigger when card enters viewport
        const obs = new IntersectionObserver(entries => {
            entries.forEach(e => { if (e.isIntersecting) { requestAnimationFrame(step); obs.disconnect(); } });
        }, { threshold: 0.3 });
        obs.observe(el);
    });
}

/* ── Scroll Reveal ───────────────────────────────────────── */
function initScrollReveal() {
    const els = document.querySelectorAll('[data-reveal]');
    if (!els.length) return;
    const obs = new IntersectionObserver(entries => {
        entries.forEach(e => {
            if (e.isIntersecting) {
                e.target.classList.add('revealed');
                obs.unobserve(e.target);
            }
        });
    }, { threshold: 0.12 });
    els.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(24px)';
        el.style.transition = 'opacity 0.55s ease, transform 0.55s ease';
        const delay = el.dataset.reveal || '0';
        el.style.transitionDelay = delay + 'ms';
        obs.observe(el);
    });
    // Add .revealed class via CSS override
    document.head.insertAdjacentHTML('beforeend',
        '<style>.revealed{opacity:1!important;transform:none!important;}</style>');
}

/* ── Button Ripple ───────────────────────────────────────── */
function initRipple() {
    document.querySelectorAll('.btn').forEach(btn => {
        btn.addEventListener('click', function(e) {
            const r = document.createElement('span');
            r.style.cssText = `
                position:absolute;border-radius:50%;transform:scale(0);
                background:rgba(255,255,255,0.25);animation:rippleAnim 0.55s linear;
                pointer-events:none;
            `;
            const rect = this.getBoundingClientRect();
            const size = Math.max(rect.width, rect.height);
            r.style.width = r.style.height = size + 'px';
            r.style.left = (e.clientX - rect.left - size / 2) + 'px';
            r.style.top  = (e.clientY - rect.top  - size / 2) + 'px';
            this.appendChild(r);
            r.addEventListener('animationend', () => r.remove());
        });
    });
    document.head.insertAdjacentHTML('beforeend', `
        <style>
          @keyframes rippleAnim {
            to { transform:scale(3); opacity:0; }
          }
        </style>
    `);
}

/* ── Canvas Particle Network (dark mode) ─────────────────── */
function initParticles() {
    if (document.documentElement.getAttribute('data-theme') === 'light') return;

    const canvas = document.createElement('canvas');
    canvas.id = 'particleCanvas';
    canvas.style.cssText = `
        position:fixed;inset:0;pointer-events:none;z-index:0;opacity:0.35;
    `;
    document.body.prepend(canvas);

    const ctx    = canvas.getContext('2d');
    let W, H, dots;

    function resize() {
        W = canvas.width  = window.innerWidth;
        H = canvas.height = window.innerHeight;
    }

    function makeParticles() {
        const count = Math.floor((W * H) / 16000);
        dots = Array.from({ length: count }, () => ({
            x: Math.random() * W,
            y: Math.random() * H,
            r: Math.random() * 1.6 + 0.4,
            vx: (Math.random() - 0.5) * 0.3,
            vy: (Math.random() - 0.5) * 0.3,
            hue: Math.random() < 0.5 ? 196 : 242   // cyan or violet
        }));
    }

    function draw() {
        ctx.clearRect(0, 0, W, H);
        // Draw connecting lines
        for (let i = 0; i < dots.length; i++) {
            for (let j = i + 1; j < dots.length; j++) {
                const dx = dots[i].x - dots[j].x;
                const dy = dots[i].y - dots[j].y;
                const d  = Math.sqrt(dx * dx + dy * dy);
                if (d < 140) {
                    ctx.beginPath();
                    ctx.strokeStyle = `hsla(${dots[i].hue},90%,70%,${(1 - d / 140) * 0.3})`;
                    ctx.lineWidth   = 0.6;
                    ctx.moveTo(dots[i].x, dots[i].y);
                    ctx.lineTo(dots[j].x, dots[j].y);
                    ctx.stroke();
                }
            }
        }
        // Draw dots
        dots.forEach(p => {
            ctx.beginPath();
            ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
            ctx.fillStyle = `hsla(${p.hue},90%,70%,0.7)`;
            ctx.fill();
            // Move
            p.x += p.vx; p.y += p.vy;
            if (p.x < 0 || p.x > W) p.vx *= -1;
            if (p.y < 0 || p.y > H) p.vy *= -1;
        });
        requestAnimationFrame(draw);
    }

    resize();
    makeParticles();
    draw();
    window.addEventListener('resize', () => { resize(); makeParticles(); });

    // Remove when light mode
    const observer = new MutationObserver(() => {
        if (document.documentElement.getAttribute('data-theme') === 'light') {
            canvas.style.display = 'none';
        } else {
            canvas.style.display = '';
        }
    });
    observer.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });
}

/* ── Confirm Delete ──────────────────────────────────────── */
function confirmDelete(name, url) {
    // Custom confirm modal
    const overlay = document.createElement('div');
    overlay.style.cssText = `
        position:fixed;inset:0;background:rgba(0,0,0,0.7);backdrop-filter:blur(6px);
        z-index:10000;display:flex;align-items:center;justify-content:center;
        animation:fadeIn 0.2s ease;
    `;
    overlay.innerHTML = `
        <div style="
            background:var(--bg-elevated);border:1px solid rgba(251,113,133,0.25);
            border-radius:20px;padding:32px;max-width:380px;width:90%;
            box-shadow:0 40px 80px rgba(0,0,0,0.6),0 0 0 1px rgba(251,113,133,0.1);
            animation:zoomIn 0.3s cubic-bezier(0.4,0,0.2,1);
            text-align:center;
        ">
            <div style="
                width:56px;height:56px;border-radius:50%;
                background:rgba(251,113,133,0.12);border:1px solid rgba(251,113,133,0.3);
                display:flex;align-items:center;justify-content:center;
                font-size:22px;color:#fb7185;margin:0 auto 18px;
                box-shadow:0 0 20px rgba(251,113,133,0.2);
            "><i class="fas fa-trash"></i></div>
            <h3 style="font-family:'Space Grotesk',sans-serif;font-size:18px;font-weight:700;margin-bottom:10px;">Delete Employee?</h3>
            <p style="color:var(--text-2);font-size:13px;margin-bottom:24px;line-height:1.6;">
                You're about to permanently remove<br>
                <strong style="color:var(--text-1)">${name}</strong>.<br>
                This cannot be undone.
            </p>
            <div style="display:flex;gap:10px;justify-content:center;">
                <button id="cancelDel" style="
                    padding:10px 22px;border-radius:10px;border:1px solid var(--border);
                    background:transparent;color:var(--text-2);cursor:pointer;font-size:13px;font-weight:600;
                    transition:all 0.2s;font-family:inherit;
                ">Cancel</button>
                <button id="confirmDel" style="
                    padding:10px 22px;border-radius:10px;border:none;
                    background:linear-gradient(135deg,#fb7185,#f43f5e);color:#fff;
                    cursor:pointer;font-size:13px;font-weight:600;
                    box-shadow:0 4px 15px rgba(251,113,133,0.35);
                    transition:all 0.2s;font-family:inherit;
                ">Delete</button>
            </div>
        </div>
    `;
    document.body.appendChild(overlay);
    overlay.querySelector('#cancelDel').onclick  = () => overlay.remove();
    overlay.querySelector('#confirmDel').onclick = () => { window.location.href = url; };
    overlay.onclick = e => { if (e.target === overlay) overlay.remove(); };
}

/* ── Form Validation ─────────────────────────────────────── */
(function () {
    const form = document.getElementById('employeeForm');
    if (!form) return;
    form.addEventListener('submit', function (e) {
        let valid = true;
        form.querySelectorAll('[required],[data-validate]').forEach(inp => {
            clearErr(inp);
            const val = inp.value.trim();
            if (inp.hasAttribute('required') && !val) { showErr(inp, 'This field is required'); valid = false; return; }
            if (inp.type === 'email' && val && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val)) { showErr(inp, 'Enter a valid email'); valid = false; }
            if (inp.name === 'salary' && val && parseFloat(val) <= 0) { showErr(inp, 'Salary must be > 0'); valid = false; }
        });
        if (!valid) e.preventDefault();
    });
    function showErr(inp, msg) {
        inp.classList.add('is-invalid');
        let fb = inp.parentElement.querySelector('.invalid-feedback');
        if (!fb) { fb = document.createElement('div'); fb.className = 'invalid-feedback'; inp.parentElement.appendChild(fb); }
        fb.innerHTML = `<i class="fas fa-circle-exclamation"></i> ${msg}`;
    }
    function clearErr(inp) {
        inp.classList.remove('is-invalid');
        const fb = inp.parentElement.querySelector('.invalid-feedback');
        if (fb) fb.textContent = '';
    }
    form.querySelectorAll('input,select').forEach(inp => inp.addEventListener('input', () => clearErr(inp)));
})();

/* ── Chart builders ──────────────────────────────────────── */
function buildDeptChart(ctx, labels, data) {
    const colors = ['#38bdf8','#818cf8','#34d399','#fbbf24','#fb7185','#a78bfa','#fb923c','#4ade80'];
    return new Chart(ctx, {
        type: 'bar',
        data: {
            labels,
            datasets: [{
                label: 'Employees', data,
                backgroundColor: colors.slice(0, labels.length),
                borderRadius: 8, borderSkipped: false,
            }]
        },
        options: {
            responsive: true, maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            animation: { duration: 1000, easing: 'easeOutQuart' },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: { stepSize: 1, color: '#64748b', font: { size: 11 } },
                    grid: { color: 'rgba(255,255,255,0.05)' }
                },
                x: {
                    ticks: { color: '#64748b', font: { size: 11 } },
                    grid: { display: false }
                }
            }
        }
    });
}

function buildStatusChart(ctx, active, inactive) {
    return new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Active', 'Inactive'],
            datasets: [{
                data: [active, inactive],
                backgroundColor: ['rgba(52,211,153,0.8)', 'rgba(251,113,133,0.8)'],
                borderColor:     ['rgba(52,211,153,1)',   'rgba(251,113,133,1)'],
                borderWidth: 2, hoverOffset: 10,
            }]
        },
        options: {
            responsive: true, maintainAspectRatio: false,
            cutout: '72%',
            animation: { animateRotate: true, duration: 1200 },
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: { color: '#94a3b8', padding: 18, boxWidth: 12, borderRadius: 4 }
                }
            }
        }
    });
}
