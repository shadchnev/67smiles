// const keyword is not supported by IE: https://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Statements/const#Description
var MINIMUM_WORKING_HOUR = 6;
var MAXIMUM_WORKING_HOUR = 22;
var DAYS_IN_A_WEEK = 7;
var WEEKDAYS = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
var MORNING = {start: MINIMUM_WORKING_HOUR, end: 12};
var AFTERNOON= {start: 12, end: 18};
var EVENING = {start: 18, end: MAXIMUM_WORKING_HOUR};

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

function sendConfirmationCode() {
  var phone = $('#client_contact_details_attributes_phone').val();
  $('#confirmation-code #error').ajaxError(function() {
    $(this).text('Sorry, there was a problem sending the code, please try again.');
  })
  $.post('/phone_confirmation_codes', {phone: phone}, function(reply) {
    switch(reply) {
      case 'ok':
        alert('The code has been sent, please check your mobile phone');
        break;
      case 'invalid':
        alert('Sorry but your phone number (' + phone + ') seems to be invalid, please check it')
        break;
      case 'sent':
        alert('We have already sent the code to your mobile phone, please check it')
        break;
      default:
        alert("An unexpected error has occurred. If you haven't received the code, please try again or email hello@varsitycleaners.co.uk for assistance")        
    }
  })
}

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

  if ((timeDiff <= 0) || !isAvailableInSelectedTime())
    error = 'Select an available time slot to calculate the price';
      
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
  setTimeout(function() {
    addDropdownOptionsToTimeSelector('#booking_start_time', MINIMUM_WORKING_HOUR, MAXIMUM_WORKING_HOUR - 1);
    addDropdownOptionsToTimeSelector('#booking_end_time', MINIMUM_WORKING_HOUR + 1, MAXIMUM_WORKING_HOUR );      
  }, 10)
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
  var commonOptions = {
    firstDay: 1, 
    dateFormat: 'dd MM'
  };
  $(selector).datepicker($.extend({
    onSelect: strategy
  }, commonOptions));
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
    $('#calendar').datepicker('setDate', new Date(parseInt(hiddenDate)*1000));
  }  
}

function haveDailyAvailability() {
  if ($('#daily-availability').length == 0)
    return;
  $('#daily-availability').data('availability', $.parseJSON($('#daily-availability #availability-json').val()));
  addCostCalculationHandlers();
  updateBookingCost();      
  updateDailyAvailability();
  setCorrectTimeSelectorValues();
}

function setCorrectTimeSelectorValues() {
  var selected_start = $('#booking_start_time_value').val();
  var selected_end = $('#booking_end_time_value').val();
  if (selected_start && selected_end) {
    setTimeout(function(){$('#booking_start_time').val(selected_start)}, 100);
    setTimeout(function(){$('#booking_end_time').val(selected_end)}, 100);    
    setTimeout(updateBookingCost, 200);
  } else if (!isAvailableInSelectedTime()) {
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
      setTimeout(function(){$('#booking_start_time').val(first_available_hour)}, 100);
      setTimeout(function(){$('#booking_end_time').val(first_available_hour+1)}, 100);
      setTimeout(updateBookingCost, 200);
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
  if (date < new Date()) return false;
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
  $('form.new_cleaner, form.edit_cleaner').submit(function() {
    removeDefaultValuesFromFields();
    saveAvailabilityTableToHiddenFields();    
  });  
  $('form#new_client').submit(function() {
    removeDefaultValuesFromFields();
  });  
}

function prepareAvailabilityTable() {  
  $("#set-availability ul").selectable({filter: 'li.selectable', stop: function(event, ui) {
    // for some reason that didn't become obvious to me after an hour of debugging,
    // IE (as opposed to other browsers) doesn't release the ctrl key after the selection.
    // Though this behaviour cannot be seen on the jquery ui website and, therefore, must be due to
    // a bug in my code, I couldn't find it. However, setting the focus to an input field prevents the
    // ctrl key from being stuck. Ugly. Ugly.
    if ($.browser.msie)
      $('#cleaner_user_attributes_password').focus();
  }});  
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
    $('input#cleaner_availability_attributes_' + days[dayIndex]).val(value);    
  })
}

function fillAvailabilityTable() {
  iterateOverAvailabilityCells(function(cells, days, dayIndex) {
    var value = $('form input#cleaner_availability_attributes_' + days[dayIndex]).val();
    for (var j=0; j <= MAXIMUM_WORKING_HOUR - MINIMUM_WORKING_HOUR; j++)
      if ((value >> (MINIMUM_WORKING_HOUR + j)) & 1) {
        $(cells[j*DAYS_IN_A_WEEK + parseInt(dayIndex)]).addClass('ui-selected');
      }
  });
}

function iterateOverAvailabilityCells(strategy) {
  var days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
  var cells = $('form .selectable');
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
          '#new-cleaner #surcharge input': 'Cleaning materials surcharge (per hour)',
          '#new-client #first-name input': 'First name',
          '#new-client #last-name input': 'Last name',
          '#new-client #phone input': 'Mobile phone',
          '#new-client #first-line input': 'First line of address',
          '#new-client #postcode input': 'Postcode',
          '#new-client #email input': 'E-mail'
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
  $.prompt('Are you a homeowner or a cleaner?', {buttons: {'I\'m a Homeowner': 'homeowner', 'I\'m a Cleaner': 'cleaner'}, callback: callback});
}

function collapseTopPart(delay) {
}

function showLoginPrompt(error, redirect_path) {
  var text = $('body > #login-form').html(); // to make the js less messy
  if (error)
    text = "<span class='error'>" + error + '</span>' + '<br/>' + text;
  var callback = function(choice,m,form) {
    var callback = function(data) {
      if (data == 'success')
        if (redirect_path)
          window.location.href = redirect_path;
        else
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

function showForgotPassword() {
  var text = $('body > #forgot-password-form').html();
  var callback = function(choice, m, form) {
    if (choice) {
      $.post('/users/send_password_link', {email: form.email});
      $.prompt.close();
      $.prompt("If the account with this email address exists, we have sent password reset instructions there");
    }
  }
  $.prompt(text, {buttons: {Ok: true, Cancel: false}, callback: callback});
  $(".jqicontainer input[type='text']").focus();
}

function loginKeyDown(e) {
  if (e.keyCode == 13)
    $('#jqi_state0_buttonOk').click();
  return false;
}