/*
-----------------------------------------------
Site: ThoughtLead
Name: People
----------------------------------------------- */

jQuery.noConflict();
jQuery(function($) {
	var people = {
		listHooks : function() {
			var classes = ['one','two','three','four','five'];
			$('.people_list li').each(function(i) {
				$(this).addClass(classes[i%5]);
				if ($(this).is(':last-child')) $(this).addClass('last');
			});
		},
		init : function() {
			people.listHooks();
		}
	};
	people.init();
});