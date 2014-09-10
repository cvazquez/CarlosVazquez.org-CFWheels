$(function() {
    $( "#HeaderSearchBox" ).autocomplete({
      source: "/blog/search",
      minLength: 2,
      select: function( event, ui ) {
      	window.location = "/blog/" + ui.item.value;
      }
    });
  });