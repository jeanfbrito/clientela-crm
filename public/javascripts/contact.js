var Contact = {
  addNestedChild: function(assoc, hide) {
    var content = $('#' + assoc + '_fields_template').html();
    if(!content) return;

    var fields_div = $('#' + assoc + '-fields');
    var regexp  = new RegExp('new_' + assoc, 'g');
    var new_id  = new Date().getTime();

    fields_div.append(content.replace(regexp, new_id));
    if (!hide) fields_div.find('.fields:last :input:first').focus();
    if (hide) fields_div.find('.fields').hide();
    return false;
  },
  
  deleteNestedChild: function(event) {
    var clicked = $(event.target);
    var hidden_field = clicked.prev('input[type=hidden]')[0];
    if(hidden_field) {
      hidden_field.value = '1';
    }
    clicked.parents('.fields').hide();
    return false;    
  },
  
  hasFields: function(assoc) {
    return ($('#' + assoc + '-fields').children().size() > 0);
  }
}

Contact.ready = function() {
  $('form').keydown(Form.keydown);

  CustomTextBoxList.configure_for('contact');

  $.each(['phones', 'emails', 'addresses', 'websites'], function(i, assoc) {
    if(!Contact.hasFields(assoc)) {
      Contact.addNestedChild(assoc, true);
    }
  });
  
  $('form a.add_child').click(function() {
    return Contact.addNestedChild($(this).attr('data-association'));
  });
  
  $('form a.remove_child').live('click', Contact.deleteNestedChild);
  
  $("#scope").change(function() {
    $(this).closest("form").submit();
  });
  
  $("#new_menu").hide();
  $("#add-favorite").click(function() {
    $(this).hide();
    $("#new_menu").show();
  });
}

$(document).ready(function() {
  Contact.ready();
  $("#contact_name").focus();
});