(function() {
  $(function() {
    var flashCallback;
    flashCallback = function() {
      return $(".alert").slideUp();
    };
    $(".flash-message").bind('click', (function(_this) {
      return function(ev) {
        return $(".alert").slideUp();
      };
    })(this));
    return setTimeout(flashCallback, 3000);
  });

}).call(this);
