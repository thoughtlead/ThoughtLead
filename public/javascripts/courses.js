/*
-----------------------------------------------
Site: ThoughtLead
Name: Courses
----------------------------------------------- */

jQuery.noConflict();
jQuery(function($) {
	var courses = {
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
		init : function() {
			courses.prepareOutline();
		}
	};
	courses.init();
});