//= require jquery.flexslider-min
//= require jquery.raty
//= require tinymce-jquery
//= require menu
//= require search
//= require nprogress
//= require select2
//= require ratyrate
//= require local_time
//= require fancybox
//= require conversations
//= require infinite-scroll

$(window).ready(function() {
  $('.flexslider').flexslider({
    animation: "slide",
    animationLoop: true,
    itemWidth: 100,
    itemMargin: 2
  });
});

$(window).ready(function() {
  $('.flexslider2').flexslider({
    animation: "slide",
    animationLoop: true,
    itemWidth: 100,
    itemMargin: 2
  });
});

$(window).ready(function() {
  $('.flexslidersm').flexslider({
    animation: "slide",
    animationLoop: true,
    itemWidth: 44,
    itemMargin: 1
  });
});

$(document).ready(function(){

    loadGallery(true, 'button.thumbnail');

    //This function disables buttons when needed
    function disableButtons(counter_max, counter_current){
        $('#show-previous-image, #show-next-image').show();
        if(counter_max == counter_current){
            $('#show-next-image').hide();
        } else if (counter_current == 1){
            $('#show-previous-image').hide();
        }
    }

    /**
     *
     * @param setIDs        Sets IDs when DOM is loaded. If using a PHP counter, set to false.
     * @param setClickAttr  Sets the attribute for the click handler.
     */

    function loadGallery(setIDs, setClickAttr){
        var current_image,
            selector,
            counter = 0;

        $('#show-next-image, #show-previous-image').click(function(){
            if($(this).attr('id') == 'show-previous-image'){
                current_image--;
            } else {
                current_image++;
            }

            selector = $('[data-image-id="' + current_image + '"]');
            updateGallery(selector);
        });

        function updateGallery(selector) {
            var $sel = selector;
            current_image = $sel.data('image-id');
            $('#image-gallery-caption').text($sel.data('caption'));
            $('#image-gallery-title').text($sel.data('title'));
            $('#image-gallery-image').attr('src', $sel.data('image'));
            disableButtons(counter, $sel.data('image-id'));
        }

        if(setIDs == true){
            $('[data-image-id]').each(function(){
                counter++;
                $(this).attr('data-image-id',counter);
            });
        }
        $(setClickAttr).on('click',function(){
            updateGallery($(this));
        });
    }
});

$(document).ready(function() {
  $('a.fancybox').fancybox();
});

jQuery(document).ready(function() {

  $(".fancybox-video").click(function() {
    $.fancybox({
      'padding'   : 0,
      'autoScale'   : false,
      'transitionIn'  : 'none',
      'transitionOut' : 'none',
      'title'     : this.title,
      'href'      : this.href.replace(new RegExp("watch\\?v=", "i"), 'v/'),
      'type'      : 'swf',
      'swf'     : {
      'wmode'       : 'transparent',
      'allowfullscreen' : 'true'
      }
    });

    return false;
  });
});

$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})