function prepareDeletePhoto() {
  $('#delete-photo').css('display', 'inline');
  // $('#master-picture img').mouseenter(function() {    
  //   $('#delete-photo').css('display', 'inline');
  // });
  // $('#master-picture img').mouseout(function() {
  //   $('#delete-photo').css('display', 'none');
  // });
}

function deletePhoto(id) {
  callback = function(v,m,f) {
    if (v) {
      $.post("/cleaners/" + id + "/delete_photo/", {}, function(data, status, xhr) {location.reload();});      
    }
  }
  $.prompt("Are you sure you want to delete your photo?", {callback: callback, buttons: {Ok: true, Cancel: false}});
}