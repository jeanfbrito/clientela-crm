module TasksHelper
  def current_tasks
    @current_tasks ||= (defined?(resource) ? resource.tasks : current_user.tasks)
  end

  def task_params
    basic_task_params.merge({:task => {:taskable_id => resource.id, :taskable_type => resource.class.base_class.name}})
  rescue ActiveRecord::RecordNotFound, NameError
    basic_task_params
  end

  def users_for_task_filter
    result = []
    result << [t("common.all"), nil]
    result << [t("common.me"), current_user.id]
    result.concat(User.all.map{ |t| [t.name, t.id]}.select {|u| u.last != current_user.id})
    options_for_select(result)
  end

  def task_format(task)
    task.frame? ? format_task_with_frame(task) : format_task_without_frame(task)
  end

  def task_category(task)
    content_tag :span, task.category.name, :class => "category", :style => %{background: ##{task.category.color}} if task.category
  end

  private
  def basic_task_params
    {:format => :js}
  end

  def format_task_without_frame(task)
    if task.today?
      task.content
    else
      "<strong>#{format_task_day(task)}</strong> &ndash; #{task.content}"
    end
  end
  
  def format_task_with_frame(task)
    if task.today?
      "<strong>#{format_task_time(task)}</strong> &ndash; #{task.content}"
    else
      "<strong>#{format_task_day(task)}</strong>, #{format_task_time(task)} &ndash; #{task.content}"
    end
  end
  
  def format_task_time(task)
    task.due_at.strftime("%H:%Mh")
  end
  
  def format_task_day(task)
    task.due_at.strftime("%d %b")
  end
end