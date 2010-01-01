$(document).ready(function() {
  var datepickerOptions = {firstDay: 1, dateFormat: 'dd MM'};
  $("#calendar").datepicker(datepickerOptions);
  $("#available-date input").datepicker(datepickerOptions);
  
})