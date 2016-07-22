// sidebar.js - JS for mobile collapsible sidebar

export function loadSidebar() {
  $('[data-toggle=sidebar]').click(function() {
    $('.row-offcanvas').toggleClass('active');
  });
}
