$(document).ready(function() {
  $("#calendar").datepicker({firstDay: 1, dateFormat: 'dd MM'});
  $("#set-availability ul").selectable({filter: 'li.selectable'});
  
  iterateOverInputLabels(function(selector, value) {
    setDefaultValue(selector, value);
    handleFocusChange(selector, value);        
  });
  
    
  $('form#new_cleaner').submit(function() {
    iterateOverInputLabels(function(selector, value) {
      unsetDefaultValue(selector, value);
    });
    
    var days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    var cells = $('form#new_cleaner .selectable');
    for (i in days) {
      var value = 0;
      for (var j=0; j < 17; j++)  // 17 is the number of hours we can possibly select in a day
        value |= ($(cells[j*7+parseInt(i)]).hasClass('ui-selected') ? 1 : 0) << (6 + j); // 6  is the 06:00, which is the minimum hour
      $('form#new_cleaner input#cleaner_availability_attributes_' + days[i]).val(value);
    }
  });
  fillAvailabilityTable();
});

function fillAvailabilityTable() {
  var days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
  var cells = $('form#new_cleaner .selectable');
  for (i in days) {
    var value = $('form#new_cleaner input#cleaner_availability_attributes_' + days[i]).val();
    for (var j=0; j < 17; j++)  // 17 is the number of hours we can possibly select in a day
      if ((value >> (6 + j)) & 1) {
        $(cells[j*7 + parseInt(i)]).addClass('ui-selected');
      }
  }
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