describe("TaskListItem", function() {
  beforeEach(function() {
    loadFixtures('task-list-item.html');
    TaskListItem.ready();
  });

  describe("panelId", function() {
    it("should generate string with panel id", function() {
      expect(TaskListItem.panelId($('#task_24'))).toEqual("#panel_task_24");
    });
  });

  describe("methods", function(){
    describe(".showEditDeleteHoverPanel", function() {
      it("should show hover panel", function() {
        var event = {
          target: $('.task-li')
        };

        TaskListItem.showEditDeleteHoverPanel(event);
        expect($('#panel_task_24')).toBeVisible();
      });
    });

    describe(".hideEditDeleteHoverPanel", function() {
      beforeEach(function(){
        $('#panel_task_24').show();
        expect($('#panel_task_24')).toBeVisible();
      });

      it("should hide hover panel", function() {
        var event = {
          target: $('.task-li')
        };

        TaskListItem.hideEditDeleteHoverPanel(event);
        expect($('#panel_task_24')).not.toBeVisible();
      });
    });
  });

//  describe("events", function(){
//    it("should show hover panel when hovering a task list item", function(){
//      spyOn(TaskListItem, 'showEditDeleteHoverPanel');
////      $("#task_24").hover(TaskListItem.showEditDeleteHoverPanel(this),TaskListItem.hideEditDeleteHoverPanel(this));
//      $("#task_24").hover();
//      expect(TaskListItem.showEditDeleteHoverPanel).toHaveBeenCalled();
//    });
//  });
});

describe("TaskForm", function() {
  beforeEach(function() {
    loadFixtures('new-task-form.html');
    TaskForm.ready();
  });

  describe("methods:", function(){
    describe("When form is visible,", function() {
      describe("#TaskForm.showDatepicker()", function() {
        it("should show datepicker if it's not visible", function() {
          TaskForm.showDatepicker();
          expect($("#task-datepicker")).toBeVisible();
        });
      });

      describe("#TaskForm.hideDatepicker()", function() {
        it("should hide datepicker if it's visible", function() {
          $("#task-datepicker").show();
          TaskForm.hideDatepicker();
          expect($("#task-datepicker")).not.toBeVisible();
        });
      });
      
					//       describe("#toggleDatepicker()", function(){
					//         it("should show datepicker if task_due is set to specific_date_time", function() {
					// $("#task_due").val('specific_date_time');
					//           TaskForm.toggleDatepicker();
					//           expect($("#task-datepicker")).toBeVisible();
					//         });
					//       
					//         it("should hide datepicker if task_due is set to anything else", function() {
					//           $("#task_due").val('other_thing');
					//           TaskForm.toggleDatepicker();
					//           expect($("#task-datepicker")).not.toBeVisible();
					//         });
					//       });
    });
  });
});