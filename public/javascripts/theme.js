registeredFlagChanged = function() {
  var enable = true;
  if ($('theme_public').checked) {
    enable = false;
  }
  $$('.theme_access_class').each(function(element) {
    if (enable) {
      element.enable();
    }
    else {
     element.checked = false;
     element.disable();
    }
  });
};

Event.observe(window, 'load', function() {
  $('theme_public').observe('change', registeredFlagChanged);
  $('theme_registered').observe('change', registeredFlagChanged);
  registeredFlagChanged();
});
