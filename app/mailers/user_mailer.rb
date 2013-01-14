class UserMailer < ActionMailer::Base
  default :from => "Clientela <mailer@clientela.com.br>"

  def task_assignment_notification(task, sender_user)
    @task, @sender_user = task, sender_user
    mail(:to => @task.assigned_to.email, :reply_to => sender_user.email, :subject => "[#{t(".user_mailer.task_notification.task")}] #{@task.content}")
  end

  def subscription_update(note, user)
    @note, @parent, @user = note, note.notable, user
    mail(:to => @user.email, :reply_to => Clientela::Base.polymorphic_email_dropbox(@parent), :subject => t(".user_mailer.subscription_update.subject", :name => @parent.name))
  end

  def task_notification(task)
    @task = task
    mail(:to => @task.assigned_to.email, :subject => "[#{t(".user_mailer.task_notification.task")}] #{@task.content}")
  end

  def fwd_misuse(user, original_subject)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :from => "Clientela <contato@clientela.com.br>", :subject => "Re: #{original_subject}")
  end

  layout 'mailer', :only => [:we_are_missing_you, :your_account_was_locked, :your_account_was_disabled, :satisfaction_survey_first_week, :welcome, :welcome_billing_cycle, :fwd_misuse]

  def we_are_missing_you(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :from => "Clientela <contato@clientela.com.br>")
  end

  def your_account_was_locked(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :from => "Clientela <contato@clientela.com.br>")
  end

  def your_account_was_disabled(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :from => "Clientela <contato@clientela.com.br>")
  end

  def satisfaction_survey_first_week(user,account)
    @user, @account = user, account
    mail(:to => "#{user.name} <#{user.email}>", :from => "Clientela <contato@clientela.com.br>")
  end
end
