/* ── Shared JS: nav, reveal, lightbox ── */

// Hamburger
document.addEventListener('DOMContentLoaded', function() {
  const hbg = document.getElementById('hamburger');
  const mob = document.getElementById('mobile-nav');
  if (hbg && mob) {
    hbg.addEventListener('click', () => mob.classList.toggle('open'));
    mob.querySelectorAll('a').forEach(a => a.addEventListener('click', () => mob.classList.remove('open')));
  }

  // Active nav link
  const page = location.pathname.split('/').pop() || 'index.html';
  document.querySelectorAll('.nav-links a, .mobile-nav a').forEach(a => {
    if (a.getAttribute('href') === page) a.classList.add('active');
  });

  // Scroll reveal
  const io = new IntersectionObserver(entries => {
    entries.forEach(e => {
      if (e.isIntersecting) { e.target.classList.add('visible'); io.unobserve(e.target); }
    });
  }, { threshold: 0.08 });
  document.querySelectorAll('.reveal').forEach(el => io.observe(el));

  // Smooth scroll
  document.querySelectorAll('a[href^="#"]').forEach(a => {
    a.addEventListener('click', function(e) {
      const t = document.querySelector(this.getAttribute('href'));
      if (t) { e.preventDefault(); window.scrollTo({ top: t.offsetTop - 84, behavior: 'smooth' }); }
    });
  });
});

// Lightbox
function openLb(src, alt) {
  const lb = document.getElementById('lightbox');
  document.getElementById('lb-img').src = src;
  document.getElementById('lb-img').alt = alt || '';
  lb.classList.add('active');
  document.body.style.overflow = 'hidden';
}
function closeLb() {
  document.getElementById('lightbox').classList.remove('active');
  document.body.style.overflow = '';
}
document.addEventListener('keydown', e => { if (e.key === 'Escape') closeLb(); });
