class SubscriptionsController < InheritedResources::Base
  respond_to :html, :xml, :json
  actions :create, :destroy
  belongs_to :contact, :company, :deal, :fact, :polymorphic => true

  def create
    params[:subscription] = {:subscriber => current_user}
    create!
  end

  protected
  def resource
   @subscription ||= end_of_association_chain.where(:subscriber_id => current_user.id).first
  end
end
