/*
-----------------------------------------------
Site: ThoughtLead
Name: Edit
----------------------------------------------- */

jQuery.noConflict();
jQuery(function($) {
	var edit = {
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
		init : function() {
			edit.repeatAttachments();
		}
	};
	edit.init();
});