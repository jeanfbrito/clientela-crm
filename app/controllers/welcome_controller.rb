class WelcomeController < ApplicationController
  def show
    redirect_to(root_url) unless current_user.welcome?
  end

  def update
    current_user.toggle!(:welcome)
    redirect_to(root_url)
  end
end