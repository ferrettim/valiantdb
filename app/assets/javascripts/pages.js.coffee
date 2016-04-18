$ ->
  flashCallback = ->
    $(".alert").slideUp()
  $(".flash-message").bind 'click', (ev) =>
    $(".alert").slideUp()
  setTimeout flashCallback, 3000