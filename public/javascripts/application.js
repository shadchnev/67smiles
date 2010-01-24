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
    })
  })
});

function iterateOverInputLabels(strategy) {
  var selectors = {
          '#new-cleaner #first-name input': 'First name',
          '#new-cleaner #last-name input': 'Last name',
          '#new-cleaner #postcode input': 'Postcode',
          '#new-cleaner #email input': 'E-mail',
          '#new-cleaner #phone-number input': 'Phone number',
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