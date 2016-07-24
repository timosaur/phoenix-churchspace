// sidebar.js - JS for mobile collapsible sidebar

export function loadSidebar() {
  $('[data-toggle=sidebar]').sidr({
    name: 'sidebar',
    displace: false,
    onOpen: function() {
      $('[data-toggle=sidebar]').addClass('active');
      $('.overlay').addClass('active');
    },
    onClose: function() {
      $('[data-toggle=sidebar]').removeClass('active');
      $('.overlay').removeClass('active');
    },
  });
}
