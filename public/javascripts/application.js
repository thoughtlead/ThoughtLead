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
			prepareFontSizer : function() {
				var fs = $('<div class="font_sizer"><span class="label">Font size: </span><ul class="size_nav replace"><li class="smaller"><a href="#0">Smaller</a></li><li class="larger"><a href="#2">Larger</a></li></ul></div>')
				// place font sizer
				$e.main_content.prepend(fs);
				thoughtlead.fontSizer.fontSizeChanger(fs);
			},
			fontSizeChanger : function(e) {
				var links = e.find('a');
				
				disableLinks();

				links.click(function() {
					var target = getLinkTarget($(this));
					thoughtlead.fontSizer.applyFontSize(target);
					updateLinks($(this));
					disableLinks();
				});
				function getLinkTarget(e) {
					var href = e.attr('href');
					var target = parseInt(href.substr(href.length-1, href.length));
					return target;
				}
				function updateLinks(e) {
					if (e.parent('li').is('.larger')) {
						links.each(function() {
							var target = getLinkTarget($(this));
							$(this).attr('href', '#'+(target+1));
						});
					} else if (e.parent('li').is('.smaller')) {
						links.each(function() {
							var target = getLinkTarget($(this));
							$(this).attr('href', '#'+(target-1));
						});
					}
				}
				function disableLinks() {
					links.each(function() {
						var target = getLinkTarget($(this));
						if (target == 0 || target == thoughtlead.fontSizer.levels.length+1) {
							$(this).addClass('inactive');
						} else {
							$(this).removeClass('inactive');
						}
					});
				}
			},
			applyFontSize : function(t) {
				$e.content.css('font-size', thoughtlead.fontSizer.levels[t-1]);
			}
		},
		repeatAttachments : function() {
			var att = $e.main_content.find('.attachments_add');
			var inp = att.children('li').clone();

			var btn = $('<button>Add another attachment</button>');

			function removeButton(e) {
				$('<a href="#" class="remove replace">Remove</a>')
					.appendTo(e)
					.click(function() {
						e.slideUp('fast', function() {$(this).remove()});
						return false;
					});
			}
			btn
				.appendTo(att)
				.click(function() {
					// clone(1) to store state before user
					// action and clone(2) to replicate.
					var this_inp = inp.clone().hide();
					this_inp.insertBefore($(this)).slideDown('fast');
					removeButton(this_inp);
					return false;
				});
		},
		peopleListHooks : function() {
			var classes = ['one','two','three','four','five'];
			$('.people_list li').each(function(i) {
				$(this).addClass(classes[i%5]);
				if ($(this).is(':last-child')) $(this).addClass('last');
			});
		},
		prepareOutline : function() {
			$e.sidebar.find('.outline > ul > li').each(function() {
				var $this = $(this);
				var header = $(this).find('h4');
				var list = $(this).find('ul');

				if (!$this.is('.active')) {
					$this.addClass('closed');
				}

				header
					.wrapInner('<a href="#"></a>')
					.click(function() {
						$this.toggleClass('closed');
						return false;
					});
			});
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
			var flash_delay = 2000;
			var flash = $e.content.find('#flash');

			if (!flash.children().length) {
				flash.remove();
			} else {
				setTimeout(function() {flash.fadeOut('fast')}, flash_delay);
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
			thoughtlead.prepareOutline();
			thoughtlead.preparePage();
			thoughtlead.repeatAttachments();
			thoughtlead.peopleListHooks();
			thoughtlead.fontSizer.prepareFontSizer();
		}
	};
	thoughtlead.init();
});