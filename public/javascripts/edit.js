/*
-----------------------------------------------
Site: ThoughtLead
Name: Edit
----------------------------------------------- */

jQuery.noConflict();
jQuery(function($) {
	var edit = {
		repeatInput : function(e, name, bind_target, bind_event, bind_function) {
			var inp = e.find('li');
			var copy = e.find('li:first-child').clone();
			var btn = $('<button>Add another '+name+'</button>');

			inp.each(function() {
				removeButton($(this));
			});
			function removeButton(e) {
				$('<a href="#" class="remove replace">Remove</a>')
					.appendTo(e)
					.click(function() {
						e.slideUp('fast', function() {$(this).remove()});
						return false;
					});
			}
			btn
				.appendTo(e)
				.click(function() {
					// clone(1) to store state before user
					// action and clone(2) to replicate.
					var this_inp = copy.clone().hide();
					this_inp.insertBefore($(this)).slideDown('fast');
					removeButton(this_inp);
					return false;
				});
		},
		newCategoryHelper : function() {
			var categories = $e.main_content.find('.categories_add');
			var new_category = $e.main_content.find('#new_category input');
			var select = categories.find('li select');

			new_category.remove();

			select.each(function() {
				var new_option = $('<option>---------------------</option><option class="new_option">New Category</option>')
				$(this).append(new_option);
			});

			$('.categories_add li select').livequery('change', function() {
				if ($(this).children('.new_option').is(':selected')) {
					new_category.clone().insertAfter($(this));
					$(this).remove();
				}
			});
		},
		profileTestLinks : function() {
			$e.main_content.find('.website').each(function() {
				var input = $(this).find('input');
				var test_link = $('<span class="hint test_link"><a target="_blank">Test link</a></span>');

				function makeLink() {
					var val = input.attr('value');
					input.before(test_link);
					if (val.length) {
						test_link.find('a').attr('href', 'http://'+val);
					} else {
						test_link.remove();
					}
				}

				makeLink();
				input.blur(makeLink);
			});
		},
		init : function() {
			if ($('body').is('.people')) {
				edit.profileTestLinks();
			} else {
				edit.newCategoryHelper();
				edit.repeatInput($e.main_content.find('.categories_add'), 'category');
				edit.repeatInput($e.main_content.find('.attachments_add'), 'attachment');
			}
		}
	};
	edit.init();
});