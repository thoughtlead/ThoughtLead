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
		init : function() {
			home.listHooks();
			home.applyCorners();
		}
	};
	home.init();
});