# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $(".brand").click ->
    window.location = '/' if window.location != '/'
    return false

  $("#action-btn").click ->
    window.location = '/sites/new'
    return false