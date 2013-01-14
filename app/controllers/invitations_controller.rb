class InvitationsController < Devise::InvitationsController
  skip_before_filter :current_account, :set_current_user, :authenticate_user!, :set_current_user_time_zone
  layout :choose_layout

  protected
  def after_invite_path_for(resource)
    users_url
  end

  def choose_layout
    if ['new','create'].include? action_name
      'application'
    else
      'invitations'
    end
  end
end