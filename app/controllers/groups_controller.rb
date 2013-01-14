class GroupsController < InheritedResources::Base
  respond_to :html, :xml, :json
  actions :new, :edit, :destroy, :index, :create, :update
  before_filter :fix_params, :only => [:update]

  private
  def fix_params
    params[:group] && (params[:group][:user_ids] ||= [])
  end
  def collection
    @groups ||= end_of_association_chain.not_individual
  end
end
