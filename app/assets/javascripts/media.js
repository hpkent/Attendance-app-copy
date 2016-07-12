$(function() {
  
  console.log("test: media index");

    // $(function() {
	$(document).on('click','#media_search input:submit',function(e) {
    	e.preventDefault();
    	//console.log(this.action);
    	//$.get(this.action, $(this).serialize(), null, 'script');
    	$.get('/media', $('#search_title').serialize(), null, 'script');
      	return false;
    });  	

	$(document).on('keyup','#search_title',function(e) {
    	e.preventDefault();
    	$.get('/media', $(this).serialize(), null, 'script');
      	return false;
    });  	

});