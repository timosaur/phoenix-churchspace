// sidebar.js - JS for mobile collapsible sidebar

export function loadSidebar() {
  $('[data-toggle=sidebar]').sidr({
    name: 'sidebar',
    displace: false,
  });
}
