var Deal = {
  submit: function(event) {
    $(event.target).closest("form").submit();
  },
  
  ready: function() {
    CustomTextBoxList.configure_for('deal');
    $('input.submit-on-change').change(Deal.submit);
  }
}

$(document).ready(function() {
  Deal.ready();
  clearUnclearOnDefaultValue('#relationship_contact_name');
});