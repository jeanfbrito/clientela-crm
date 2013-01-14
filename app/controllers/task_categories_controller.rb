class TaskCategoriesController < InheritedResources::Base
  respond_to :js
  actions :new, :create, :edit, :update
  
  def update
    update! do |format|
      format.html { redirect_to(:back) }
    end
  end

  def create
    create! do |format|
      format.html { redirect_to(:back) }
    end
  end
end