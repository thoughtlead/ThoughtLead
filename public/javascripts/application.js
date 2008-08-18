/*
-----------------------------------------------
Site: ThoughtLead
Name: Application
----------------------------------------------- */

jQuery.noConflict();
var thoughtlead;
jQuery(function($) {
	thoughtlead = {
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
		preparePage : function() {
			// add markup: clouds
			var clouds = $('<div id="navigation_art" class="clouds clear"></div>');
			$e.navigation.wrapInner(clouds);

			// add markup: content wrapper
			$e.content.wrap('<div id="content_wrap" class="content_area"></div>');

			// ie background flickering
			try {document.execCommand("BackgroundImageCache", false, true);} catch(err) {}

			// add markup: comment bubble
			$('ol.comment li, div.comment').each(function() {
				var bubble = $('<div class="bubble">&nbsp;</div>');
				$(this).find('.item_content').prepend(bubble);
			});

			// full width article lists
			$('ul.article_list')
				.addClass('full_width')
				.children('li').addClass('item').end()
				.children('li:odd').addClass('odd').end();
		},
		fontSizer : {
			levels : [
				'1em',
				'1.15em',
				'1.3em'
			],
			buildChanger : function() {
				var fs = $('<div class="font_sizer"><span class="label">Font size: </span><ul class="size_nav replace"><li class="smaller"><a href="#smaller">0</a></li><li class="current"><a>1</a></li><li class="larger"><a href="#larger">2</a></li></ul></div>')
				// place font sizer
				$e.main_content.prepend(fs);
				thoughtlead.fontSizer.prepareChanger(fs);
			},
			prepareChanger : function(e) {
				var links = e.find('li');
				var changer = {
					smaller: e.find('.smaller a'),
					current: e.find('.current a'),
					larger: e.find('.larger a')
				};

				function checkPrefs() {
					if ($.cookie('fontPref')) {
						setCount($.cookie('fontPref'));
					} else {
						$.cookie('fontPref', 1, {expires: 31})
					}
				}
				function setPrefs(target) {
					$.cookie('fontPref', target);
				}
				function getCount(e) {
					return e.text();
				}
				function setCount(current) {
					var i = current - 1;
					$.each(changer, function() {
						$(this).text(i);
						i++;
					});
				}
				function disableLinks() {
					links.each(function() {
						var target = getCount($(this));
						var link = $(this).children('a');
						if (target <= 0 || target >= thoughtlead.fontSizer.levels.length+1) {
							link.addClass('inactive');
						} else {
							link.removeClass('inactive');
						}	
					});					
				}
				function applySize(target) {
					$e.content.css('font-size', thoughtlead.fontSizer.levels[target-1]);
				}
				function changeSize(e) {
					var target = getCount(e);
					applySize(target);
					setCount(target);
					setPrefs(target);
					disableLinks();
				}

				checkPrefs();
				changeSize(changer.current);
				links.click(function() {
					changeSize($(this));
					return false;
				});
			},
			init : function() {
				thoughtlead.fontSizer.buildChanger();
			}
		},
		prepareInputs : function(e) {
			e.find('input[type=text]')
				.addClass('inactive')
				.focus(function() {
					$(this).removeClass('inactive').attr('value', '');
				});
		},
		validSearchTest : function() {
			$e.page.find('.search').each(function() {
				var $form = $(this);
				$(this).find('.btn_image').click(function() {
					var value = $form.find('.inp_text').attr('value');
					processedSearchString = value.strip();
					return processedSearchString != '' && processedSearchString != 'Search...';
				});
			});
		},
		prepareFlashNotice : function() {
			var min_delay = 2000;
			var flash = $e.content.find('#flash');
			var close = $('<a class="close replace" href="#">Close</a>');

			close.click(function() {
				flash.fadeOut('fast');
				return false;
			});
			if (!flash.children().length) {
				flash.remove();
			} else {
				flash.fadeTo(1, 0.9);
				flash.prepend(close);
			}
		},
		prepareButtons : function() {
			$('.make_button').each(function() {
				var button = $('<div class="button clear"><a href="#submit"><span class="icon"></span></a></div>');
				button
					.find('span')
						.addClass($(this).attr('id'))
						.text($(this).attr('value'))
					.end()
					.click(function() {
						$(this).parents('form').submit();
						return false;
					});
				$(this)
					.hide()
					.after(button);
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
			thoughtlead.markupCorners($e.content.find('#flash'));
			thoughtlead.markupCorners($e.main_content.find('.meta_tags li'));
			thoughtlead.markupCorners($e.main_content.find('.module'));
			thoughtlead.markupCorners($e.main_content.find(".banner"));
			thoughtlead.markupCorners($e.header.find('#account_nav'), ['bl', 'br']);
			thoughtlead.markupCorners($e.navigation.find('#content_nav li'), ['tl', 'tr']);

			var mod_nav = $e.sidebar.find('.navigation > ul');
			mod_nav.addClass('stroke');
			thoughtlead.markupCorners(mod_nav, ['tr', 'br']);
		},
		init : function() {
			$e = thoughtlead.elements;
			thoughtlead.prepareFlashNotice();
			thoughtlead.prepareButtons();
			thoughtlead.applyCorners();
			thoughtlead.prepareInputs($('.search'));
			thoughtlead.validSearchTest();
			thoughtlead.preparePage();
			thoughtlead.fontSizer.init();
		}
	};
	thoughtlead.init();
});