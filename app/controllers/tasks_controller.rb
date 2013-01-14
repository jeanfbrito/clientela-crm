class TasksController < InheritedResources::Base
  respond_to :html, :xml, :json
  respond_to :js, :only => [:new, :edit, :complete, :destroy]
  actions :all, :except => [:show]
  custom_actions :collection => :completed
  has_scope :assigned_to_id

  def create
    assigned_to_id = params[:task][:assigned_to_id].blank? ? current_user.id : params[:task][:assigned_to_id]
    @task = Task.new(params[:task].merge(:assigned_to_id => assigned_to_id, :created_by => current_user))

    create! do |format|
      format.html { redirect_to(:back) }
    end
  end

  def update
    update! do |format|
      format.html { redirect_to(:back) }
    end
  end

  def completed
    @tasks = Task.completed
    completed!
  end
  
  def complete
    @task = Task.find(params[:id])
    @task.complete
    render :nothing => true
  end
end
