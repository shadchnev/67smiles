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
  fillTimeSelectors();
  haveDailyAvailability();  
  updateTimeHiddenField();
  removeNotice();
});

function removeNotice() {
  setTimeout(function() {$("#flash .notice").slideUp()}, 20000);
}

function addCostCalculationHandlers() {
  $('#new-booking #booking_cleaning_materials_provided, #new-booking #booking_start_time, #new-booking #booking_end_time').change(function() {updateBookingCost()});
}

function updateTimeHiddenField() {
  if ($('#calendar').length == 0)
    return;
  var date = $('#calendar').datepicker('getDate');
  $('#booking_date').val(date.getTime() / 1000);
}

function updateBookingCost() {
  if ($('#new-booking').length == 0)
    return;
  $('#new-booking #cost').empty();
  var error;
  var rate = $('.hourly-rate-value').val();
  if (!rate)
    error = 'Cannot determine the current hourly rate';
  var timeFrom = $('#new-booking #booking_start_time').val();
  var timeTo = $('#new-booking #booking_end_time').val();

  var timeDiff = timeTo - timeFrom;

  if (timeDiff <= 0)
    error = 'Please correct the time';
  else {
    if (!isAvailableInSelectedTime())
      error = 'The selected time is not available';
  }
      
  var surcharge = 0;
  if ($('#new-booking #booking_cleaning_materials_provided').val() == 0)
    surcharge = parseFloat($('#new-booking #cleaning_materials_surcharge').val());  
  var message;
  if (error) {
    message = error;
    $('#booking_submit').attr("disabled","disabled");
  } else {
    var parsedRate = rate.match(/^\d+\.0$/) ? parseInt(rate) : parseFloat(rate);    
    var hourly_value = surcharge ? '(&pound;' + parsedRate + ' + &pound;' + surcharge.toString() + ')' : '&pound;' + parsedRate;
    var total = (parseFloat(rate) + parseFloat(surcharge)) * timeDiff;
    var s = timeDiff > 1 ? 's' : '';
    message = hourly_value + ' &times; ' + timeDiff + ' hour' + s + ' = &pound;' + total;
    $('#booking_submit').removeAttr("disabled");
  }
  $('#new-booking #cost').append(message);
}

function isAvailableInSelectedTime() {
  if ($('#new-booking').length == 0)
    return;  
  var availability =  $('#daily-availability').data('availability');
  var date = $("#calendar").datepicker('getDate');
  var timeFrom = $('#new-booking #booking_start_time').val();
  var timeTo = $('#new-booking #booking_end_time').val();  
  return isAvailableIn(availability, date, {start: timeFrom, end: timeTo}, true)  
}

function fillTimeSelectors() {
  if ($('#time-selectors').length == 0)
    return;
  addDropdownOptionsToTimeSelector('#booking_start_time', MINIMUM_WORKING_HOUR, MAXIMUM_WORKING_HOUR - 1);
  addDropdownOptionsToTimeSelector('#booking_end_time', MINIMUM_WORKING_HOUR + 1, MAXIMUM_WORKING_HOUR );
}

function addDropdownOptionsToTimeSelector(selector, minimumTime, maximumTime) {
  for (var i = minimumTime; i <= maximumTime; i++) {
    var selected = $('#time-selectors ' + selector + '_value').val() == i.toString();
    addDropdownOption('#time-selectors ' + selector, i, pad(i) + ':00', selected);
  }  
}

function addDropdownOption(selector, value, label, selected) {
  var selected = selected ? 'selected="selected"' : '';
  $(selector).append($('<option value="' + value + '" ' + selected + '>' + label + '</option>'));
}

function prepareCalendarForPage(selector, strategy) {
  var common_options = {
    firstDay: 1, 
    dateFormat: 'dd MM',
  };
  $(selector).datepicker($.extend({
    onSelect: strategy
  }, common_options));
}

function prepareCalendar() {  
  prepareCalendarForPage('#new-booking #calendar', function(date, instance) {      
    updateDailyAvailability();
    updateTimeHiddenField();
    updateBookingCost();      
  });
  prepareCalendarForPage('#find-a-cleaner #calendar', function(date, instance) {updateTimeHiddenField();});
  prepareCalendarForPage('#availability #calendar', function(date, instance) {updateDailyAvailability();});  
  var hiddenDate = $('#booking_date').val();
  if (hiddenDate) {
    console.log('Syncing calendar to ' + hiddenDate);
    $('#calendar').datepicker('setDate', new Date(parseInt(hiddenDate)*1000));
    console.log("Now calendar is " + $('#calendar').datepicker('getDate'));
  }  
}

function haveDailyAvailability() {
  if ($('#daily-availability').length == 0)
    return;
  $('#daily-availability').data('availability', JSON.parse($('#daily-availability #availability').val()));
  addCostCalculationHandlers();
  updateBookingCost();      
  updateDailyAvailability();
  setCorrectTimeSelectorValues();
}

function setCorrectTimeSelectorValues() {
  if (!isAvailableInSelectedTime()) {
    var availability =  $('#daily-availability').data('availability');
    var date = $("#calendar").datepicker('getDate');
    var selected_availability = availability[WEEKDAYS[date.getDay()]];
    var first_available_hour;
    for (var j=MINIMUM_WORKING_HOUR; j <= MAXIMUM_WORKING_HOUR; j++) {
      if (selected_availability >> j & 1) {
        first_available_hour = j;
        break;
      }
    }
    if (first_available_hour) {
      $('#booking_start_time').val(pad(first_available_hour) + ':00');
      $('#booking_end_time').val(pad(first_available_hour + 1) + ':00');
      updateBookingCost();
    }
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

function minimumHire() {
  return $('#minimum-hire').val();
}

function isAvailableIn(availability, date, period, complete) {  
  if (minimumHire() > period.end - period.start) return false;
  var mask = ((Math.pow(2, period.end - period.start)  - 1) << period.start);
  var partialAvailability = mask & availability[WEEKDAYS[date.getDay()]];
  if (complete) return partialAvailability == mask;
  return partialAvailability;
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
  $('form#new_client').submit(function() {
    removeDefaultValuesFromFields();
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
          '#new-cleaner #hourly-rate input': 'Hourly rate',
          '#new-cleaner #surcharge input': 'Cleaning materials surcharge',
          '#new-client #first-name input': 'First name',
          '#new-client #last-name input': 'Last name',
          '#new-client #phone input': 'Mobile phone',
          '#new-client #first-line input': 'First line of address',
          '#new-client #postcode input': 'Postcode',
          '#new-client #email input': 'E-mail',
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

function selectRegistrationType() {
  var callback = function(choice,m,f) {
    if (choice == 'homeowner')
      document.location = '/clients/new'
    else if (choice == 'cleaner')
      document.location = '/cleaners/new'    
  }
  $.prompt('Are you a homeowner or a cleaner?', {buttons: {Homeowner: 'homeowner', Cleaner: 'cleaner'}, callback: callback});
}

function collapseTopPart() {
  var callback = function() {
    $('#find-a-cleaner').color_fade();
    $('#find-a-cleaner #where input').focus();    
  }
  $('#left-column #master-picture-container').slideUp(500);
  $('#right-column #content #summary-block').slideUp(500, callback);
}

function showLoginPrompt(error) {
  var text = $('body > #login-form').html(); // to make the js less messy
  if (error)
    text = "<span class='error'>" + error + '</span>' + '<br/>' + text;
  var callback = function(choice,m,form) {
    var callback = function(data) {
      if (data == 'success')
        window.location.reload();
      else
        showLoginPrompt(data);
    }
    if (choice)
      $.post('/user_sessions', {login: form.login, password: form.password}, callback);
  }
  $.prompt(text, {buttons:{Ok: true, Cancel: false}, callback: callback});
  $(".jqicontainer input[type='text']").focus();
}

function loginKeyDown(e) {
  if (e.keyCode == 13)
    $('#jqi_state0_buttonOk').click();
  return false;
}