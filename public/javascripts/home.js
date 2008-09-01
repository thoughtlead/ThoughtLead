/*
-----------------------------------------------
Site: ThoughtLead
Name: Home
----------------------------------------------- */

jQuery.noConflict();
jQuery(function($) {
	var home = {
		listHooks : function() {
			$('.section_list li:odd').addClass('row_end');
		},
		applyCorners : function() {
			thoughtlead.markupCorners($e.main_content.find('.banner'));
		},
		screenshotPNG : function() {
			var image = $('.banner .image');
			var src = image.find('img').attr('src');

			if ($.browser.msie && parseInt($.browser.version) == 6) {
				image.css('filter','progid:DXImageTransform.Microsoft.AlphaImageLoader(src="'+src+'", sizingMethod="image");')
			}
		},
		init : function() {
			home.listHooks();
			home.applyCorners();
			home.screenshotPNG();
		}
	};
	home.init();
});