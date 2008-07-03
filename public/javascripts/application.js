/*
-----------------------------------------------
Site: ThoughtLead
Name: Application
----------------------------------------------- */

jQuery.noConflict();
jQuery(function($) {
	var thoughtlead = {
		elements : {
			page: $('#page'),
				header: $('#header'),
				navigation: $('#navigation'),
				content: $('#content'),
					primary: $('#primary'),
					secondary: $('#secondary'),
				footer: $('#footer')
		},
		prepareInputs : function() {
			$('input[type=text]')
				.addClass('inactive')
				.focus(function() {
					$(this).removeClass('inactive').attr('value', '');
				});
		},
		markupCorners : function(e, o) {
			if (typeof o == 'undefined') {o = ['tl', 'tr', 'bl', 'br']}
			var corner = $('<div class="corner"><!-- --></div>');
			var corners = {
				tl: corner.clone().addClass('top left top_left'),
				tr: corner.clone().addClass('top right top_right'),
				bl: corner.clone().addClass('bottom left bottom_left'),
				br: corner.clone().addClass('bottom right bottom_right')
			}
			e.addClass('corner_container');
			$.each(o, function(i, c) {
				e.append(corners[c]);
			});
		},
		applyCorners : function() {
			thoughtlead.markupCorners($e.header.find("#search"));
			thoughtlead.markupCorners($e.header.find('#account_nav'), ['bl', 'br']);
			thoughtlead.markupCorners($e.navigation.find('#content_nav li'), ['tl', 'tr']);
			thoughtlead.markupCorners($e.secondary.find("ul.actions li"));

			var mod_nav = $e.secondary.find('.navigation ul');
			mod_nav.addClass('stroke');
			thoughtlead.markupCorners(mod_nav, ['tr', 'br']);
		},
		init : function() {
			$e = thoughtlead.elements;
			thoughtlead.applyCorners();
			thoughtlead.prepareInputs();
		}
	};
	thoughtlead.init();
});