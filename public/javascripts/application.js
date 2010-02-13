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
  haveDailyAvailability();
  fillTimeSelectors();
  addCostCalculationHandlers();
  updateBookingCost();
});

function addCostCalculationHandlers() {
  $('#new-booking #calendar').datepicker('option', 'onSelect', function(dateText, instance) {updateBookingCost()});
  $('#new-booking #surcharge, #new-booking #time-from, #new-booking #time-to').change(function() {updateBookingCost()});
}

function updateBookingCost() {
  $('#new-booking #cost').empty();
  var error;
  var rate = $('.hourly-rate-value').val();
  if (!rate)
    error = 'Cannot determine the current hourly rate';
  var timeFrom = $('#new-booking #time-from').val();
  var timeTo = $('#new-booking #time-to').val();

  var timeDiff = timeDifference(timeFrom, timeTo);

  if (timeDiff <= 0)
    error = 'Please check the selected time:' + timeDiff;
    
  var surcharge = $('#new-booking #surcharge').val();  
  var message;
  if (error)
    message = error;
  else {
    var parsedRate = rate.match(/^\d+\.0$/) ? parseInt(rate) : parseFloat(rate);    
    var hourly_value = parseFloat(surcharge) ? '(&pound;' + parsedRate + ' + &pound;' + surcharge + ')' : '&pound;' + parsedRate;
    var total = (parseFloat(rate) + parseFloat(surcharge)) * timeDiff;
    var s = timeDiff > 1 ? 's' : '';
    message = hourly_value + ' &times; ' + timeDiff + ' hour' + s + ' = &pound;' + total;
  }
  $('#new-booking #cost').append(message);
}

function timeDifference(from, to) {
  const MINUTES_IN_AN_HOUR = 60.0;
  var fromTime = parseTimeValue(from);
  var toTime = parseTimeValue(to);
  if (!(fromTime && toTime)) return;
  return ((toTime.hour * MINUTES_IN_AN_HOUR + toTime.minutes) - (fromTime.hour * MINUTES_IN_AN_HOUR + fromTime.minutes)) / MINUTES_IN_AN_HOUR;
}

function parseTimeValue(time) {
  var regex = /(0(\d)|(\d\d)):(\d0)/; 
  match = time.match(regex);
  if (!match) return;
  var hour = parseInt(match[2] || match[1]); // because parseInt('06') == 6, while parseInt('08') == 0
  var minutes = parseInt(match[4]);
  return {hour: hour, minutes: minutes};
}

function fillTimeSelectors() {
  if ($('#time-selectors').length == 0)
    return;
  addDropdownOptionsToTimeSelector('#time-from', MINIMUM_WORKING_HOUR, MAXIMUM_WORKING_HOUR - 1);
  addDropdownOptionsToTimeSelector('#time-to', MINIMUM_WORKING_HOUR + 1, MAXIMUM_WORKING_HOUR );
}

function addDropdownOptionsToTimeSelector(selector, minimumTime, maximumTime) {
  for (var i = minimumTime; i <= maximumTime; i++) {
    addDropdownOption('#time-selectors ' + selector, pad(i) + ':00');
    if (i < maximumTime)
      addDropdownOption('#time-selectors ' + selector, pad(i) + ':30');
  }  
}

function addDropdownOption(selector, value) {
  $(selector).append($('<option>' + value + '</option>'));
}

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
  if ($('#daily-availability').length == 0)
    return;
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
  if (!availability) return;
  $('#daily-availability .timespan').remove();
  var periods = {morning: MORNING, afternoon: AFTERNOON, evening: EVENING};
  for (period in periods)
    if (isAvailableIn(availability, date, periods[period])) {
      $('#daily-availability #' + period).show();
      showAvailableHours(availability, date, $('#daily-availability #' + period), periods[period]);
    } else {
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
  if (character.toString().length == 1) return '0' + character;
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