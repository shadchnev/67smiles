const MINIMUM_WORKING_HOUR = 6
const MAXIMUM_WORKING_HOUR = 22
const DAYS_IN_A_WEEK = 7
const WEEKDAYS = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
const MORNING = {start: MINIMUM_WORKING_HOUR, end: 12};
const AFTERNOON= {start: 12, end: 18};
const EVENING = {start: 18, end: MAXIMUM_WORKING_HOUR};


$(document).ready(function() {
  prepareCalendar();
  prepareAvailabilityTable();
  prepareFormFields();    
  addFormSubmitHandlers();
  fillAvailabilityTable();
  if ($('#daily-availability').length)
    haveDailyAvailability();
});

function prepareCalendar() {
  $("#calendar").datepicker({
    firstDay: 1, 
    dateFormat: 'dd MM',
    onSelect: function(date, instance) {
      updateDailyAvailability();
    }
  });
}

function haveDailyAvailability() {
  var cleanerId = $('#cleaner-id').val();
  if (cleanerId) {
    $.getJSON('/cleaners/availability', {id: cleanerId}, function(data) {
      $('#daily-availability').data('availability', data)
      updateDailyAvailability();
    });
  }
}

function updateDailyAvailability() {
  var date = $("#calendar").datepicker('getDate');
  var availability = $('#daily-availability').data('availability');
  $('#daily-availability .timespan').remove();
  var periods = {morning: MORNING, afternoon: AFTERNOON, evening: EVENING};
  for (period in periods)
    if (isAvailableIn(availability, date, periods[period])) {
      $('#daily-availability #' + period).show();
      showAvailableHours(availability, date, $('#daily-availability #' + period), periods[period]);
    } else {
      // alert('n/a: ' + period);
      $('#daily-availability #' + period).append("<div class='timespan'>Not available</div>");
    }
}

function isAvailableIn(availability, date, period) {
  var mask = ((Math.pow(2, period.end - period.start)  - 1) << period.start);
  return mask & availability[WEEKDAYS[date.getDay()]];
}

function showAvailableHours(availability, date, node, period) {
  var weekday_availability = availability[WEEKDAYS[date.getDay()]];
  var from, to;
  for (var i = period.start; i < period.end; i++) {
    if (weekday_availability & 1 << i) {
      if (from == undefined) from = i;
      if ((!(weekday_availability & 1 << i + 1)) || ((i + 1) == period.end)) {
        to = i + 1;        
        node.append("<div class='timespan'>" + pad(from) + ':00 &mdash; ' + pad(to) + ":00</div>");
        from = undefined;
      }
    }
  }
}

function pad (character) {
  if (character.length == 1)
    return '0' + character;
  return character;
}

function addFormSubmitHandlers() {
  $('form#new_cleaner').submit(function() {
    removeDefaultValuesFromFields();
    saveAvailabilityTableToHiddenFields();    
  });  
}

function prepareAvailabilityTable() {  
  $("#set-availability ul").selectable({filter: 'li.selectable'});  
}

function prepareFormFields() {
  iterateOverInputLabels(function(selector, value) {
    setDefaultValue(selector, value);
    handleFocusChange(selector, value);        
  });  
}

function removeDefaultValuesFromFields() {
  iterateOverInputLabels(function(selector, value) {
    unsetDefaultValue(selector, value);
  });
}

function saveAvailabilityTableToHiddenFields() {
  iterateOverAvailabilityCells(function(cells, days, dayIndex) {
    var value = 0;
    for (var j=0; j <= MAXIMUM_WORKING_HOUR - MINIMUM_WORKING_HOUR; j++)
      value |= ($(cells[j*DAYS_IN_A_WEEK+parseInt(dayIndex)]).hasClass('ui-selected') ? 1 : 0) << (MINIMUM_WORKING_HOUR + j);
    $('form#new_cleaner input#cleaner_availability_attributes_' + days[dayIndex]).val(value);    
  })
}

function fillAvailabilityTable() {
  iterateOverAvailabilityCells(function(cells, days, dayIndex) {
    var value = $('form#new_cleaner input#cleaner_availability_attributes_' + days[dayIndex]).val();
    for (var j=0; j <= MAXIMUM_WORKING_HOUR - MINIMUM_WORKING_HOUR; j++)
      if ((value >> (MINIMUM_WORKING_HOUR + j)) & 1)
        $(cells[j*DAYS_IN_A_WEEK + parseInt(dayIndex)]).addClass('ui-selected');
  });
}

function iterateOverAvailabilityCells(strategy) {
  var days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
  var cells = $('form#new_cleaner .selectable');
  for (dayIndex in days)
    strategy(cells, days, dayIndex);  
}

function iterateOverInputLabels(strategy) {
  var selectors = {
          '#new-cleaner #first-name input': 'First name',
          '#new-cleaner #last-name input': 'Last name',
          '#new-cleaner #postcode input': 'Postcode',
          '#new-cleaner #email input': 'E-mail',
          '#new-cleaner #phone-number input': 'Phone number',
          '#new-cleaner #rate input': 'Hourly rate',
          '#new-cleaner #surcharge input': 'Cleaning materials surcharge',
          };
  for (var selector in selectors) {
    var value = selectors[selector];
    strategy(selector, value);
  }
}

function setDefaultValue(selector, value) {
  if ($(selector).val() == '') {      
    $(selector).val(value);
  }
}

function unsetDefaultValue(selector, value) {
  if ($(selector).val() == value) {      
    $(selector).val('');
  }
}

function handleFocusChange(selector, value) {
  $(selector).focus(function() {
    if ($(this).val() == value) {
      $(this).val('');
    }
  })    
  $(selector).blur(function() {
    if ($(this).val() == '') {
      $(this).val(value);
    }
  })    
}