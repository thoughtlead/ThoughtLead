registeredFlagChanged = function() {
  var enable = true;
  if ($('content_public').checked) {
    enable = false;
  }
  $$('.content_access_class').each(function(element) {
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
  $('content_public').observe('change', registeredFlagChanged);
  $('content_registered').observe('change', registeredFlagChanged);
  registeredFlagChanged();
});
