// 1. Reading Progress Bar
window.addEventListener('scroll', () => {
    let winScroll = document.body.scrollTop || document.documentElement.scrollTop;
    let height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
    let scrolled = (winScroll / height) * 100;
    document.getElementById("myBar").style.width = scrolled + "%";
});

// 2. The Observer Effect (Mouse Glow)
const glow = document.getElementById('glow');
let mouseX = window.innerWidth / 2;
let mouseY = window.innerHeight / 2;
let glowX = mouseX;
let glowY = mouseY;

// Track mouse position
document.addEventListener('mousemove', (e) => {
    mouseX = e.clientX;
    mouseY = e.clientY;
});

// Smoothly animate the glow toward the mouse (easing)
function animateGlow() {
    // Math for smooth trailing effect
    glowX += (mouseX - glowX) * 0.05;
    glowY += (mouseY - glowY) * 0.05;

    glow.style.left = `${glowX}px`;
    glow.style.top = `${glowY}px`;

    requestAnimationFrame(animateGlow);
}
animateGlow();

// 3. Cascading Fade-in Observer
document.addEventListener('DOMContentLoaded', () => {
    const fadeItems = document.querySelectorAll('.fade-item');

    const observerOptions = {
        root: null,
        rootMargin: '0px 0px -10% 0px', // Triggers slightly before bottom
        threshold: 0.1
    };

    const observer = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    fadeItems.forEach(item => {
        observer.observe(item);
    });
});
