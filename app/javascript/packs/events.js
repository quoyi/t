$(function() {
  window.dispatchEvent(new Event("resize"));

  $('body').scrollspy({ target: '#static-scroll' });

  $('.toast').toast({ delay: 2000 }).toast('show');
});