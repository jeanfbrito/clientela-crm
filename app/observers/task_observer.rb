class TaskObserver < ActiveRecord::Observer
  def after_create(task)
    Activity.create(params(task).merge(:action => "create"))
  end

  def before_update(task)
    Activity.create(params(task).merge(:action => "done")) if task.done_at_changed?
  end
  
  private
  def params(task)
    category = task.category.nil? ? "" : "#{task.category.name}: "
    {:activitable => task, :record => {:name => category + task.content, :type => "task", :id => task.id}}
  end
end
