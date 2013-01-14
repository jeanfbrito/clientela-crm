var Company = {}

Company.ready = function() {
  CustomTextBoxList.configure_for('company');
}

$(document).ready(function() {
  Company.ready();
});