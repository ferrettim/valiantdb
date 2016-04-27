var ready;
 
ready = function(){
    // enable select2 js
    $('.chosen-select').select2({
    	create_option: true,
        no_results_text: 'No results matched'
    });
}

 
$(document).ready(ready);
// if using turbolinks
$(document).on("page:load",ready);