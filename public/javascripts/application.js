$(document).ready(function() {
  $("#calendar").datepicker({firstDay: 1, dateFormat: 'dd MM'});
  $("#set-availability ul").selectable({filter: 'li.selectable'});
  
})