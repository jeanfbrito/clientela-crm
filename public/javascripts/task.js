var TaskListItem = {
  panelId: function(html_object) {
    return '#panel_' + html_object.attr('id');
  },

  showEditDeleteHoverPanel: function(event) {
    var task_item = $(event.target).closest(".task-li");
    $(TaskListItem.panelId(task_item)).show();
  },

  hideEditDeleteHoverPanel: function(event) {
    $('.panel-task').hide();
    $('.task-info').hide();
  },

  ready: function() {
    $('.task-li').live('mouseover',TaskListItem.showEditDeleteHoverPanel).live('mouseout',TaskListItem.hideEditDeleteHoverPanel);
  }
};

var TaskForm = {
  showDatepicker: function() {
    $("#task-datepicker").show();
  },

  hideDatepicker: function() {
    $("#task-datepicker").hide();
  },

  toggleDatepicker: function() {
    var index = $("#task_due").val();
    var specific_date_time_index = 4;
    if(index == specific_date_time_index) {
      return false;
    }
    var date = eval(task_due[index]);
    $("#new_datepicker").datepicker("setDate",date);
    $("#task_due_at_1i").attr("value", date.getFullYear());
    $("#task_due_at_2i").attr("value", date.getMonth()+1);
    $("#task_due_at_3i").attr("value", date.getDate());
    $("span.selected-date").html($.datepicker.formatDate('dd/mm/yy', date));
    return false;
  },

  complete: function(event) {
    element = $(event.target);
    if(element.attr('checked')) {
      element.attr('disabled', 'disabled');
      element.closest("li").addClass("done").delay(4000).slideUp('slow');
      element.closest("form").submit();
    }
    return false;
  },

  ready: function() {
    $("#task_due").live('change', TaskForm.toggleDatepicker);
  }
};

function extensibleField(id) {
  $(id).keypress(function(){
    var lenght = $(id).width() / 8;
    $(id).height((parseInt($(id).val().length / lenght) + 1) * 16)
  });
}

function setDatePicker() {
  $("#new_datepicker").datepicker({
    changeMonth: true,
    changeYear: true,
    onSelect: function(dateText, inst) {
      var date = dateText.split("/");
      $("span.selected-date").html(dateText);
      $("#task_due_at_1i").attr("value", date[2]);
      $("#task_due_at_2i").attr("value", date[1]);
      $("#task_due_at_3i").attr("value", date[0]);
    }
  });
}

$(document).ready(function() {
  TaskListItem.ready();
  TaskForm.ready();

  $('input.submit-on-check').live('change', TaskForm.complete);

  extensibleField("#task_content");
});