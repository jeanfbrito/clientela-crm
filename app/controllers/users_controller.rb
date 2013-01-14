class UsersController < InheritedResources::Base
  respond_to :html, :xml, :json
  actions :all, :except => [:new, :create, :show]
  before_filter :admin?, :only => [:destroy]

  def index
    @users = User.active
  end

  def edit
    @user = User.find(params_id_or_false_if_not_current_user)
    edit!
  end

  def update
    @user = User.find(params_id_or_false_if_not_current_user)

    update! do |success, failure|
      success.html do
        sign_in :user, @user, :bypass => true
        redirect_to edit_user_url(@user)
      end
    end
  end

  def destroy
    @user = User.find(params_id_or_false_if_current_user)
    destroy!
  end

  def update_authentication_token
    current_user.reset_authentication_token!
    redirect_to edit_user_url(current_user)
  end

  def survey
    current_user.update_survey(params[:survey])
    render :nothing => true
  end

  private
  def admin?
    unless current_user.admin?
      raise ActionController::UnknownAction.new("You don't have access to this action.")
    end
  end

  def params_id_or_false_if_not_current_user
    params[:id].to_i == current_user.id && params[:id]
  end

  def params_id_or_false_if_current_user
    params[:id].to_i != current_user.id && params[:id]
  end
end
