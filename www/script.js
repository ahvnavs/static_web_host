// 1. Theme Toggle Logic
const themeToggle = document.getElementById('theme-toggle');
const moonIcon = document.getElementById('moon-icon');
const sunIcon = document.getElementById('sun-icon');

// Check saved theme or default to dark
const currentTheme = localStorage.getItem('theme') || 'dark';
document.documentElement.setAttribute('data-theme', currentTheme);
updateToggleIcon(currentTheme);

themeToggle.addEventListener('click', () => {
    let theme = document.documentElement.getAttribute('data-theme');
    let newTheme = theme === 'dark' ? 'light' : 'dark';

    document.documentElement.setAttribute('data-theme', newTheme);
    localStorage.setItem('theme', newTheme);
    updateToggleIcon(newTheme);
});

function updateToggleIcon(theme) {
    if (theme === 'dark') {
        moonIcon.style.display = 'block';
        sunIcon.style.display = 'none';
    } else {
        moonIcon.style.display = 'none';
        sunIcon.style.display = 'block';
    }
}

// 2. Reading Progress Bar
window.addEventListener('scroll', () => {
    let winScroll = document.body.scrollTop || document.documentElement.scrollTop;
    let height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
    let scrolled = (winScroll / height) * 100;
    document.getElementById("myBar").style.width = scrolled + "%";
});

// 3. Interactive Element: Quantum Ripple on Click
document.addEventListener('click', function(e) {
    // Prevent ripple if clicking a link or the theme button so it doesn't interrupt standard UI interactions
    if(e.target.closest('button') || e.target.closest('a')) return;

    let ripple = document.createElement('div');
    ripple.className = 'ripple';
    document.body.appendChild(ripple);

    // Calculate exact click coordinates relative to the document
    let size = 100; // Ripple size in pixels
    ripple.style.width = ripple.style.height = `${size}px`;
    ripple.style.left = `${e.clientX - size/2}px`;
    ripple.style.top = `${e.clientY + window.scrollY - size/2}px`;

    // Cleanup DOM after animation
    setTimeout(() => {
        ripple.remove();
    }, 600);
});

// 4. The Observer Effect (Mouse Cursor Glow)
// We check for 'pointer: fine' so this only runs on devices with an actual mouse cursor
if (window.matchMedia("(pointer: fine)").matches) {
    const glow = document.getElementById('glow');
    let mouseX = window.innerWidth / 2;
    let mouseY = window.innerHeight / 2;
    let glowX = mouseX;
    let glowY = mouseY;

    document.addEventListener('mousemove', (e) => {
        mouseX = e.clientX;
        mouseY = e.clientY;
    });

    // Request Animation Frame loop creates a buttery smooth dragging effect behind the cursor
    function animateGlow() {
        glowX += (mouseX - glowX) * 0.05;
        glowY += (mouseY - glowY) * 0.05;

        glow.style.left = `${glowX}px`;
        glow.style.top = `${glowY}px`;

        requestAnimationFrame(animateGlow);
    }
    animateGlow();
}

// 5. Cascading Fade-in Observer
document.addEventListener('DOMContentLoaded', () => {
    const fadeItems = document.querySelectorAll('.fade-item');

    const observerOptions = {
        root: null, // Viewport
        rootMargin: '0px 0px -10% 0px', // Triggers slightly before the element hits the bottom
        threshold: 0.1
    };

    const observer = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                // Unobserve after fading in so it doesn't trigger repeatedly
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    fadeItems.forEach(item => {
        observer.observe(item);
    });
});
