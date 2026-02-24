// ========================================
// Network Canvas Animation
// ========================================

class NetworkAnimation {
    constructor(canvas) {
        this.canvas = canvas;
        this.ctx = canvas.getContext('2d');
        this.particles = [];
        this.particleCount = 50;
        this.connections = [];
        this.mouse = { x: null, y: null, radius: 150 };
        
        this.resize();
        this.init();
        this.animate();
        
        // Event listeners
        window.addEventListener('resize', () => this.resize());
        canvas.addEventListener('mousemove', (e) => this.handleMouseMove(e));
        canvas.addEventListener('mouseleave', () => this.handleMouseLeave());
    }
    
    resize() {
        this.canvas.width = this.canvas.offsetWidth;
        this.canvas.height = this.canvas.offsetHeight;
    }
    
    init() {
        this.particles = [];
        for (let i = 0; i < this.particleCount; i++) {
            this.particles.push({
                x: Math.random() * this.canvas.width,
                y: Math.random() * this.canvas.height,
                vx: (Math.random() - 0.5) * 0.5,
                vy: (Math.random() - 0.5) * 0.5,
                radius: Math.random() * 2 + 1
            });
        }
    }
    
    handleMouseMove(e) {
        const rect = this.canvas.getBoundingClientRect();
        this.mouse.x = e.clientX - rect.left;
        this.mouse.y = e.clientY - rect.top;
    }
    
    handleMouseLeave() {
        this.mouse.x = null;
        this.mouse.y = null;
    }
    
    update() {
        this.particles.forEach(particle => {
            // Update position
            particle.x += particle.vx;
            particle.y += particle.vy;
            
            // Bounce off edges
            if (particle.x < 0 || particle.x > this.canvas.width) particle.vx *= -1;
            if (particle.y < 0 || particle.y > this.canvas.height) particle.vy *= -1;
            
            // Mouse interaction
            if (this.mouse.x !== null && this.mouse.y !== null) {
                const dx = this.mouse.x - particle.x;
                const dy = this.mouse.y - particle.y;
                const distance = Math.sqrt(dx * dx + dy * dy);
                
                if (distance < this.mouse.radius) {
                    const force = (this.mouse.radius - distance) / this.mouse.radius;
                    particle.vx -= (dx / distance) * force * 0.5;
                    particle.vy -= (dy / distance) * force * 0.5;
                }
            }
            
            // Damping
            particle.vx *= 0.99;
            particle.vy *= 0.99;
        });
    }
    
    draw() {
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
        
        // Draw connections
        this.particles.forEach((p1, i) => {
            this.particles.slice(i + 1).forEach(p2 => {
                const dx = p1.x - p2.x;
                const dy = p1.y - p2.y;
                const distance = Math.sqrt(dx * dx + dy * dy);
                
                if (distance < 150) {
                    const opacity = (1 - distance / 150) * 0.3;
                    this.ctx.strokeStyle = `rgba(255, 149, 0, ${opacity})`;
                    this.ctx.lineWidth = 0.5;
                    this.ctx.beginPath();
                    this.ctx.moveTo(p1.x, p1.y);
                    this.ctx.lineTo(p2.x, p2.y);
                    this.ctx.stroke();
                }
            });
        });
        
        // Draw particles
        this.particles.forEach(particle => {
            this.ctx.fillStyle = 'rgba(255, 149, 0, 0.8)';
            this.ctx.beginPath();
            this.ctx.arc(particle.x, particle.y, particle.radius, 0, Math.PI * 2);
            this.ctx.fill();
        });
        
        // Draw mouse connection
        if (this.mouse.x !== null && this.mouse.y !== null) {
            this.particles.forEach(particle => {
                const dx = this.mouse.x - particle.x;
                const dy = this.mouse.y - particle.y;
                const distance = Math.sqrt(dx * dx + dy * dy);
                
                if (distance < this.mouse.radius) {
                    const opacity = (1 - distance / this.mouse.radius) * 0.5;
                    this.ctx.strokeStyle = `rgba(0, 212, 255, ${opacity})`;
                    this.ctx.lineWidth = 1;
                    this.ctx.beginPath();
                    this.ctx.moveTo(particle.x, particle.y);
                    this.ctx.lineTo(this.mouse.x, this.mouse.y);
                    this.ctx.stroke();
                }
            });
        }
    }
    
    animate() {
        this.update();
        this.draw();
        requestAnimationFrame(() => this.animate());
    }
}

// ========================================
// Smooth Scroll Navigation
// ========================================

class SmoothScroll {
    constructor() {
        this.links = document.querySelectorAll('a[href^="#"]');
        this.init();
    }
    
    init() {
        this.links.forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                const targetId = link.getAttribute('href');
                if (targetId === '#') return;
                
                const targetElement = document.querySelector(targetId);
                if (targetElement) {
                    const offsetTop = targetElement.offsetTop - 80;
                    window.scrollTo({
                        top: offsetTop,
                        behavior: 'smooth'
                    });
                }
            });
        });
    }
}

// ========================================
// Navbar Scroll Effect
// ========================================

class NavbarScroll {
    constructor() {
        this.nav = document.querySelector('.nav');
        this.lastScroll = 0;
        this.init();
    }
    
    init() {
        window.addEventListener('scroll', () => {
            const currentScroll = window.pageYOffset;
            
            if (currentScroll > 100) {
                this.nav.style.background = 'rgba(10, 14, 23, 0.95)';
                this.nav.style.boxShadow = '0 4px 16px rgba(0, 0, 0, 0.3)';
            } else {
                this.nav.style.background = 'rgba(10, 14, 23, 0.9)';
                this.nav.style.boxShadow = 'none';
            }
            
            this.lastScroll = currentScroll;
        });
    }
}

// ========================================
// Intersection Observer for Animations
// ========================================

class ScrollAnimations {
    constructor() {
        this.observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -100px 0px'
        };
        this.init();
    }
    
    init() {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('animate-in');
                }
            });
        }, this.observerOptions);
        
        // Observe all sections
        const sections = document.querySelectorAll('section');
        sections.forEach(section => {
            observer.observe(section);
        });
        
        // Observe architecture cards
        const cards = document.querySelectorAll('.architecture-card');
        cards.forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(30px)';
            card.style.transition = `opacity 0.6s ease ${index * 0.1}s, transform 0.6s ease ${index * 0.1}s`;
            
            observer.observe(card);
        });
        
        // Observe certification cards
        const certCards = document.querySelectorAll('.cert-card');
        certCards.forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(30px)';
            card.style.transition = `opacity 0.6s ease ${index * 0.1}s, transform 0.6s ease ${index * 0.1}s`;
            
            observer.observe(card);
        });
    }
}

// Add CSS for animate-in class
const style = document.createElement('style');
style.textContent = `
    .animate-in.architecture-card,
    .animate-in.cert-card {
        opacity: 1 !important;
        transform: translateY(0) !important;
    }
`;
document.head.appendChild(style);

// ========================================
// Mobile Navigation Toggle
// ========================================

class MobileNav {
    constructor() {
        this.toggle = document.querySelector('.nav-toggle');
        this.menu = document.querySelector('.nav-menu');
        this.links = document.querySelectorAll('.nav-link');
        this.init();
    }
    
    init() {
        if (!this.toggle) return;
        
        this.toggle.addEventListener('click', () => {
            this.toggleMenu();
        });
        
        this.links.forEach(link => {
            link.addEventListener('click', () => {
                if (window.innerWidth <= 768) {
                    this.closeMenu();
                }
            });
        });
    }
    
    toggleMenu() {
        this.toggle.classList.toggle('active');
        this.menu.classList.toggle('active');
        
        if (this.menu.classList.contains('active')) {
            this.menu.style.display = 'flex';
            this.menu.style.flexDirection = 'column';
            this.menu.style.position = 'absolute';
            this.menu.style.top = '100%';
            this.menu.style.left = '0';
            this.menu.style.right = '0';
            this.menu.style.background = 'rgba(10, 14, 23, 0.98)';
            this.menu.style.padding = '2rem';
            this.menu.style.gap = '1rem';
            this.menu.style.borderTop = '1px solid rgba(255, 255, 255, 0.1)';
        } else {
            this.closeMenu();
        }
    }
    
    closeMenu() {
        this.toggle.classList.remove('active');
        this.menu.classList.remove('active');
        
        if (window.innerWidth <= 768) {
            this.menu.style.display = 'none';
        } else {
            this.menu.style.display = 'flex';
            this.menu.style.flexDirection = 'row';
            this.menu.style.position = 'static';
            this.menu.style.background = 'none';
            this.menu.style.padding = '0';
            this.menu.style.borderTop = 'none';
        }
    }
}

// ========================================
// Stats Counter Animation
// ========================================

class StatsCounter {
    constructor() {
        this.metrics = document.querySelectorAll('.metric-value');
        this.animated = false;
        this.init();
    }
    
    init() {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting && !this.animated) {
                    this.animateCounters();
                    this.animated = true;
                }
            });
        }, { threshold: 0.5 });
        
        const metricsSection = document.querySelector('.hero-metrics');
        if (metricsSection) {
            observer.observe(metricsSection);
        }
    }
    
    animateCounters() {
        this.metrics.forEach(metric => {
            const text = metric.textContent;
            const hasPercent = text.includes('%');
            const hasPlus = text.includes('+');
            const hasMinus = text.includes('-');
            
            let target = parseFloat(text.replace(/[^0-9.]/g, ''));
            
            if (hasMinus) target = -target;
            
            let current = 0;
            const increment = target / 50;
            const timer = setInterval(() => {
                current += increment;
                
                if ((increment > 0 && current >= target) || (increment < 0 && current <= target)) {
                    current = target;
                    clearInterval(timer);
                }
                
                let display = Math.abs(current).toFixed(current % 1 === 0 ? 0 : 2);
                if (hasMinus) display = '-' + display;
                if (hasPlus) display = '+' + display;
                if (hasPercent) display += '%';
                
                metric.textContent = display;
            }, 30);
        });
    }
}

// ========================================
// Typing Effect for Hero Title
// ========================================

class TypingEffect {
    constructor() {
        this.titleHighlight = document.querySelector('.title-highlight');
        if (!this.titleHighlight) return;
        
        this.originalText = this.titleHighlight.textContent;
        this.init();
    }
    
    init() {
        this.titleHighlight.textContent = '';
        this.titleHighlight.style.borderRight = '3px solid var(--color-accent-primary)';
        
        let index = 0;
        const typeInterval = setInterval(() => {
            if (index < this.originalText.length) {
                this.titleHighlight.textContent += this.originalText.charAt(index);
                index++;
            } else {
                clearInterval(typeInterval);
                setTimeout(() => {
                    this.titleHighlight.style.borderRight = 'none';
                }, 500);
            }
        }, 100);
    }
}

// ========================================
// Architecture Card Interactive Hover
// ========================================

class ArchitectureCards {
    constructor() {
        this.cards = document.querySelectorAll('.architecture-card');
        this.init();
    }
    
    init() {
        this.cards.forEach(card => {
            card.addEventListener('mouseenter', (e) => {
                this.createParticles(e.currentTarget);
            });
        });
    }
    
    createParticles(card) {
        const icon = card.querySelector('.card-icon');
        if (!icon) return;
        
        // Add a subtle scale animation to the icon
        icon.style.transform = 'scale(1.1) rotate(5deg)';
        setTimeout(() => {
            icon.style.transform = 'scale(1) rotate(0deg)';
        }, 300);
    }
}

// ========================================
// Parallax Effect
// ========================================

class ParallaxEffect {
    constructor() {
        this.init();
    }
    
    init() {
        window.addEventListener('scroll', () => {
            const scrolled = window.pageYOffset;
            const parallaxElements = document.querySelectorAll('.hero-background');
            
            parallaxElements.forEach(element => {
                const speed = 0.5;
                element.style.transform = `translateY(${scrolled * speed}px)`;
            });
        });
    }
}

// ========================================
// Timeline Progress Indicator
// ========================================

class TimelineProgress {
    constructor() {
        this.timeline = document.querySelector('.timeline');
        if (!this.timeline) return;
        
        this.init();
    }
    
    init() {
        const progressLine = document.createElement('div');
        progressLine.className = 'timeline-progress';
        progressLine.style.cssText = `
            position: absolute;
            left: 0;
            top: 0;
            width: 2px;
            height: 0;
            background: linear-gradient(to bottom, var(--color-accent-primary), var(--color-accent-secondary));
            transition: height 0.3s ease;
            z-index: 1;
        `;
        
        this.timeline.appendChild(progressLine);
        
        window.addEventListener('scroll', () => {
            const timelineRect = this.timeline.getBoundingClientRect();
            const windowHeight = window.innerHeight;
            
            if (timelineRect.top < windowHeight && timelineRect.bottom > 0) {
                const visibleHeight = Math.min(
                    windowHeight - timelineRect.top,
                    this.timeline.offsetHeight
                );
                const percentage = (visibleHeight / this.timeline.offsetHeight) * 100;
                progressLine.style.height = `${percentage}%`;
            }
        });
    }
}

// ========================================
// Page Load Animation
// ========================================

class PageLoadAnimation {
    constructor() {
        this.init();
    }
    
    init() {
        window.addEventListener('load', () => {
            document.body.style.opacity = '0';
            document.body.style.transition = 'opacity 0.5s ease';
            
            setTimeout(() => {
                document.body.style.opacity = '1';
            }, 100);
        });
    }
}

// ========================================
// Initialize All Components
// ========================================

document.addEventListener('DOMContentLoaded', () => {
    // Initialize network canvas animation
    const canvas = document.getElementById('network-canvas');
    if (canvas) {
        new NetworkAnimation(canvas);
    }
    
    // Initialize smooth scroll
    new SmoothScroll();
    
    // Initialize navbar scroll effect
    new NavbarScroll();
    
    // Initialize scroll animations
    new ScrollAnimations();
    
    // Initialize mobile navigation
    new MobileNav();
    
    // Initialize stats counter
    new StatsCounter();
    
    // Initialize typing effect
    new TypingEffect();
    
    // Initialize architecture cards
    new ArchitectureCards();
    
    // Initialize parallax effect
    new ParallaxEffect();
    
    // Initialize timeline progress
    new TimelineProgress();
    
    // Initialize page load animation
    new PageLoadAnimation();
    
    console.log('✓ Portfolio initialized successfully');
});

// ========================================
// Easter Egg: Console Message
// ========================================

console.log(
    '%c¡Hola Developer! 👋',
    'color: #ff9500; font-size: 24px; font-weight: bold;'
);
console.log(
    '%cSi estás leyendo esto, probablemente te interesa la tecnología tanto como a mí.',
    'color: #00d4ff; font-size: 14px;'
);
console.log(
    '%c¿Hablamos? → sanchezcarlos.ti@gmail.com',
    'color: #10b981; font-size: 14px; font-weight: bold;'
);