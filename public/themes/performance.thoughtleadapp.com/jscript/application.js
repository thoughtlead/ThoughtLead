jQuery.noConflict();
var turnaround;
jQuery(function($) {
																turnaround = {
		elements : {
			page: $('#page'),
				header: $('#header'),
				navigation: $('#navigation'),
				content: $('#content'),
					content_bar: $('.content_bar'),
					main_content: $('#main_content'),
					sidebar: $('#sidebar'),
				footer: $('#footer')
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
			turnaround.markupCorners($e.header.find("#search"));
			turnaround.markupCorners($e.header.find('.account_nav'), ['bl', 'br']);
			turnaround.markupCorners($e.navigation.find('#content_nav li'), ['tl', 'tr']);
	turnaround.markupCorners($e.content.find(".banner"));
		turnaround.markupCorners($e.content.find("#sidebar #form_section"), ['br', 'tr']);
		turnaround.markupCorners($e.content.find("#sidebar #navigation_themes"), ['br', 'tr']);
		
	
			var mod_nav = $e.sidebar.find('.navigation > ul');
			mod_nav.addClass('stroke');
			turnaround.markupCorners(mod_nav, ['tr', 'br']);
		},
		init : function() {
			$e = turnaround.elements;
			turnaround.applyCorners();
		}
	};
	turnaround.init();
});