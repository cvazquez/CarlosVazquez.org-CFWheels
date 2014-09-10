$.widget("ui.verboseautocomplete", $.extend({}, $.ui.autocomplete.prototype, {

  _response: function(contents){
      $.ui.autocomplete.prototype._response.apply(this, arguments);
      $(this.element).trigger("autocompletesearchcomplete", [contents]);
      //alert("response")
  }

}));

(function($) {
	
	//multiautocomplete is called upon loading the page from \admin\app\webroot\js\posts\edit.js
	$.fn.multiautocomplete = function(options) {
		var options			= options || {};
		options.formField	= options.formField || "";

		// itemList is binded to <ul class="item-list categories"> and we'll loop through each <li>
		var itemList = this;
		
		// Will hold all the categories
		var names = [];
		
		// Used to create the indexed array for the HABTM relation between a Post and its Categories
		var postCategoryCounter = 0;
		
		// This will hold all the selected categories to pass through the form
		var outArray = [];
		

		function setOutput(){
			
			var categoryIdField;
			var postIdField;
			var postIdValue = document.getElementById("PostId").value;
			var x;
			
			// Find already selected (active) categories, and add to the outArray
			itemList.find("li.active").each(function(){
				
				// Check if it already exists
				if(outArray.indexOf($(this).attr("item")) == -1) 	
				{
					
					outArray.push($(this).attr("item"));
					
					categoryIdField = '<input type="hidden" class="categories" name="data[Category][' + postCategoryCounter + '][id]" value="' + $(this).attr("item") + '">';
					$("#select_categories").append(categoryIdField);
					postCategoryCounter++;
				}
			});
			
			// Append the value in $(this).attr("item") to the hidden field id of options.formField (categories in this case)			
			//$(options.formField).val(outArray.toString());
			//$(options.formField).change();
			
			// Try an alternate of creating multiple hidden categoryId fields, that way they pass as an array on form post
			
			//console.log(outArray);
			/*
			for(x in outArray)
			{
				// TODO - check if category id already exists in another hidden category id field
				//$("#select_categories").append('<input type="hidden" class="categories" name="data[CategoryPost][categoryids]" value="' + outArray[x] + '">');
				
				
				// Create an array of category_id and post_id fields to work with the HABTM 
				// data[CategoryPost][0][Category][id] = outArray[x];
				//categoryIdField = '<input type="hidden" class="categories" name="data[CategoryPost][' + postCategoryCounter + '][Category][id]" value="' + outArray[x] + '">';
				//categoryIdField = '<input type="hidden" class="categories" name="data[Category][' + postCategoryCounter + '][id]" value="' + outArray[x] + '">';
				//$("#select_categories").append(categoryIdField);
				
				// data[CategoryPost][0][Post][id] = outArray[x];
				//postIdField = '<input type="hidden" name="data[CategoryPost][' + postCategoryCounter + '][Post][id]" value="' + postIdValue + '">';
				//$("#select_categories").append(postIdField);
				
				//postCategoryCounter++;
			}
			*/
			
		}

		// Add all the categories to the names array
		itemList.find("li").each(function(){
			names.push({label:$(this).attr("title"), value:$(this).attr("item")});
		});

		itemList.find("a.close").click(function(){
			var parentItem = $(this).parent();
			var parentItemValue = parentItem.attr("item");
			var v;
			var categoryValue;
			var index = outArray.indexOf(parentItemValue);

			// Remove the selected category from the active list displayed
			parentItem.slideUp('fast',function(){parentItem.removeClass('active');setOutput();});
			
			// Remove category from the hidden categories class fields
			$.each($(".categories"), function(key, value)
				{
					// If the category looped over equals the category removed, then remove this categories hidden field
					categoryValue = $(".categories")[key].value;
					if (parentItemValue == categoryValue)
						{
							// Found hidden field with this categories value and remove
							$(this).remove();
							
							// Also remove from the outArray, which allows us to add it back again.
							if (index > -1) {
								outArray.splice(index, 1);
							}
						}
				});
			
			return false;
		});

		// Just finding the input field within the item list 
		var _InputField = itemList.find("input");		
		
		// Listen to any events on the input field
		_InputField.verboseautocomplete({
			minLength: 0,
	    	source: names,
	    	select: function(event, ui){
	    		var selectedItem = itemList.find("li[item="+ui.item.value+"]");
	    		selectedItem.slideDown('fast',function(){selectedItem.addClass('active');setOutput();});
	    		_InputField.val('');
	    		
				return false;
			},
			focus: function( event, ui ) {
				// Only works if the mouse is focusing on it, not the arrow keys
				$(".item-input").val(ui.item.label); 
			}
		}).bind("autocompletesearchcomplete", function(event, contents) {
		    if(contents.length == 0){
		    	$(this).autocomplete("widget").html('<li><p class="ui-corner-all">No results found.</p></li>');
		    	$(this).autocomplete("widget").show();
		    }		    
		});

		setOutput();
	}
})(jQuery);