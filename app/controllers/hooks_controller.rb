class HooksController < ApplicationController
  skip_before_filter :set_current_user, :authenticate_user!, :set_current_user_time_zone

  def wufoo
    begin
      user = User.find_by_authentication_token!(params[:HandshakeKey])
    rescue ActiveRecord::RecordNotFound
      render :status => :unauthorized, :nothing => true
      return
    end

    unless contact = find_contact_by_email
      contact = Contact.create!(
        :name => contact_name,
        :emails_attributes => [{:address => contact_email, :kind => "work"}],
        :phones_attributes => [{:number => contact_phone, :kind => "work"}]
      )
      contact.relationships.create!(:entity => Deal.create!(:name => "Startup DEV - #{contact_name}", :assigned_to => user, :value => 6000, :value_type => "fixed"))
    end
    Task.create!(:taskable => contact, :content => "Contato pelo site", :due_at => (Date.tomorrow.end_of_day - 6.hours + 1.second), :assigned_to => user, :created_by => user, :category => TaskCategory.find_by_name("Retorno"))

    render :nothing => true
  end

  private
  def find_contact_by_email
    email = Email.where(:address => contact_email).first
    email && email.entity
  end

  def contact_name
    params[:Field11]
  end

  def contact_email
    params[:Field5]
  end

  def contact_phone
    params[:Field4]
  end
end