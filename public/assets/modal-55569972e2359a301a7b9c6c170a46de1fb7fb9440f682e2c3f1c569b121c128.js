document.addEventListener('DOMContentLoaded', function () {

var rootEl = document.documentElement;
var $modals = getAll('.modal');
var $modalButtons = getAll('.modal-button');
var $modalCloses = getAll('.modal-background, .modal-close, .modal-card-head .delete, .modal-card-foot .button');

if ($modalButtons.length > 0) {
  $modalButtons.forEach(function ($el) {
    $el.addEventListener('click', function () {
      var target = $el.dataset.target;
      var $target = document.getElementById(target);
      var toggle = $el.dataset.toggle;
      var $toggle = document.getElementById(toggle);
      rootEl.classList.add('is-clipped');
      $target.classList.add('is-active','fadeIn');
      $target.classList.remove('fadeOut');
      $toggle.classList.add('fadeOut');
      setTimeout(function () {
          $toggle.classList.remove('is-active','fadeIn');
      } , 300);
    });
  });
}

if ($modalCloses.length > 0) {
  $modalCloses.forEach(function ($el) {
    $el.addEventListener('click', function () {
      closeModals();
    });
  });
}

document.addEventListener('keydown', function (event) {
  var e = event || window.event;
  if (e.keyCode === 27) {
    closeModals();
  }
});

function closeModals() {
  rootEl.classList.remove('is-clipped');
  $modals.forEach(function ($el) {
    $el.classList.add('fadeOut');
    setTimeout(function () {
        $el.classList.remove('is-active');
    } , 300);
  });
}

function getAll(selector) {
  return Array.prototype.slice.call(document.querySelectorAll(selector), 0);
}

});
