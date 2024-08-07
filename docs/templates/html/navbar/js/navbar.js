/* Website Theme */
// Initial theme, based on device setting
if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
  document.body.classList.add('dark');
  document.getElementById('themeColorMeta').setAttribute('content', '#0b1120');

} else {
  document.body.classList.remove('dark');
  document.getElementById('themeColorMeta').setAttribute('content', '#06233d');
}

// Listen for changes in the preferred color scheme
window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
  if (e.matches) {
    document.body.classList.add('dark');
    document.getElementById('themeColorMeta').setAttribute('content', '#0b1120');
  } else {
    document.body.classList.remove('dark');
    document.getElementById('themeColorMeta').setAttribute('content', '#06233d');
  }
});


/* Navbar submenu handling for touch devices */
document.querySelectorAll('.nav-item').forEach(item => {
  item.addEventListener('touchstart', event => {
    event.preventDefault();
    const parentContainer = event.currentTarget.closest('.nav-item-container');
    document.querySelectorAll('.nav-item-container').forEach(container => {
      if (container !== parentContainer) {
        container.querySelector('.nav-item').classList.remove('touch');
      }
    });
    parentContainer.querySelector('.nav-item').classList.toggle('touch');
  });
});

/* To close submenu when clicked outside */
document.addEventListener('touchstart', event => {
  if (!event.target.closest('.nav-item-container')) {
    document.querySelectorAll('.nav-item-container').forEach(container => {
      container.querySelector('.nav-item').classList.remove('touch');
    });
  }
});

/* Handle hamburger menu open/close */
const hamBtn = document.getElementById('ham-btn');
const hamIcon = document.getElementById('ham-icon');
const closeIcon = document.getElementById('close-icon');
const mobileMenu = document.getElementById('mobile-menu');

hamBtn.addEventListener('click', () => {
  mobileMenu.classList.toggle('open');
  hamIcon.classList.toggle('hidden');
  closeIcon.classList.toggle('hidden');
  if (mobileMenu.classList.contains('open')) {
    document.body.style.overflow = "hidden";
  } else {
    document.body.style.overflow = "auto";
  }
});

/* Handle hamburger submenu selection */
document.querySelectorAll('.mobile-nav-item').forEach(item => {
  item.addEventListener('click', event => {
      const submenu = item.querySelector('.mobile-nav-submenu');
      const menuHeader = item.querySelector('.mobile-nav-item-header');
      if (submenu) {
        submenu.classList.toggle('open');
        menuHeader.classList.toggle('touch');
      }
  });
});

/* Scroll Top functionality */
const scrollToTopBtn = document.getElementById("scrollToTopBtn");

window.onscroll = function() {
  if (document.body.scrollTop > 500 || document.documentElement.scrollTop > 500) {
    scrollToTopBtn.style.display = "block";
  } else {
    scrollToTopBtn.style.display = "none";
  }
};

scrollToTopBtn.addEventListener('click', () => {
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  });
});