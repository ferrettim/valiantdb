$(function () {
    $('a[href="#searchpopup"]').on('click', function(event) {
        event.preventDefault();
        $('#searchpopup').addClass('open');
        $('#searchpopup > form > input[type="search"]').focus();
    });
    
    $('#searchpopup, #searchpopup button.close').on('click keyup', function(event) {
        if (event.target == this || event.target.className == 'close' || event.keyCode == 27) {
            $(this).removeClass('open');
        }
    });
    
    $('#searchpopupsubmit').submit(function(event) {
        event.preventDefault();
        return false;
    })
});
