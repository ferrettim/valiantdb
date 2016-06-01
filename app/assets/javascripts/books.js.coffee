$(document).ready ->
  $(".collection-filter").on "change", ->
    $.ajax
      url: "/collection"
      type: "GET"
      dataType: "script"
      data:
        title: $(".collection-filter").val()