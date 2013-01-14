var Note = {
  toggleOptions: function() {
    $('div.note-form-basics').toggle();
    $('div.note-form-extras').toggle();
    return false;    
  },
  
  ready: function() {
    $('.note-show-more-options').click(Note.toggleOptions);
    $('.note-hide-more-options').click(Note.toggleOptions);
  }
}

$(document).ready(function() {
  Note.ready();
});