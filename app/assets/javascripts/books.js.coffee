$(document).ready ->
  $('.best_in_place').best_in_place()
  
$(document).ready ->
  $(".collection-filter").on "change", ->
    $.ajax
      url: "/collection"
      type: "GET"
      dataType: "script"
      data:
        title: $(".collection-filter").val()