# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserMailer do
  let!(:account) { FactoryGirl.create(:example) }
  let!(:user) { FactoryGirl.create(:quentin) }
  let!(:user) { FactoryGirl.create(:quentin, id: "99999") }

  before(:each) do
    Account.current = account
  end

  describe "task_assignment_notification" do
    let!(:user) { FactoryGirl.create(:fake) }

    before(:each) do
      @user = user
    end

    describe "regular task" do
      before(:each) do
        @task = FactoryGirl.create(:specified_datetime)
        @email = UserMailer.task_assignment_notification(@task, @user)
      end

      it "should have from" do
        @email.from.should == ["mailer@clientela.com.br"]
      end

      it "should have to" do
        @email.to.should == [@task.assigned_to.email]
      end

      it "should have reply_to" do
        @email.reply_to.should == ["fake@example.com"]
      end

      it "should have subject" do
        @email.subject.should == "[Tarefa] blas"
      end

      it "should have right body" do
        @email.body.to_s.should == read_custom_fixture("task_assignment_notification")
      end
    end

    describe "task associated to a contact" do
      let!(:contact) { FactoryGirl.create(:contact_joseph, id: "99999", imported_by: nil, emails: [FactoryGirl.create(:email)], phones: [FactoryGirl.create(:phone)]) }

      it "should have right body" do
        task = FactoryGirl.create(:task_pending, taskable: contact)
        UserMailer.task_assignment_notification(task, @user).body.to_s.should == read_custom_fixture("task_assignment_notification_with_associated_contact")
      end
    end

    describe "task associated to a company" do
      it "should have right body" do
        task = FactoryGirl.create(:task_yesterday_done, taskable: FactoryGirl.create(:company_helabs, id: "99999"))
        UserMailer.task_assignment_notification(task, @user).body.to_s.should == read_custom_fixture("task_assignment_notification_with_associated_company")
      end
    end

    describe "task associated to a deal" do
      it "should have right body" do
        task = FactoryGirl.create(:task_tomorrow, taskable: FactoryGirl.create(:quentin_deal_won, id: "99999"))
        UserMailer.task_assignment_notification(task, @user).body.to_s.should == read_custom_fixture("task_assignment_notification_with_associated_deal")
      end
    end

    describe "task associated to a fact" do
      it "should have right body" do
        task = FactoryGirl.create(:task_tomorrow_done, taskable: FactoryGirl.create(:fact, id: "99999"))
        UserMailer.task_assignment_notification(task, @user).body.to_s.should == read_custom_fixture("task_assignment_notification_with_associated_fact")
      end
    end
  end

  describe "subscription_update" do
    {:contact => :note_quentin, :company => :note_helabs, :deal => :note_quentin_deal_won, :fact => :note_service_order}.each do |model, note_fixture|
      describe "on #{model} note" do
        before(:each) do
          @note = FactoryGirl.create(note_fixture)
          @user = FactoryGirl.create(:quentin)
          n = @note.notable
          n.id = "99999"
          n.save

          @email = UserMailer.subscription_update(@note, @user)
        end

        it "should have from" do
          @email.from.should == ["mailer@clientela.com.br"]
        end

        it "should have to" do
          @email.to.should == [@user.email]
        end

        it "should have subject" do
          @email.subject.should == "[ATUALIZAÇÃO] #{@note.notable.name}"
        end

        it "should have right body" do
          @email.body.to_s.should == read_custom_fixture("subscription_update_for_#{model}")
        end

        it "should have reply-to" do
          @email.reply_to.should == ["dropbox+#{account.domain}+#{model}+#{@note.notable.id}@clientela.com.br"]
        end
      end
    end
  end

  describe "task_notification" do
    describe "regular task" do
      before(:each) do
        @task = FactoryGirl.create(:task_today, due_at: 3.hours.from_now)
        @email = UserMailer.task_notification(@task)
      end

      it "should have from" do
        @email.from.should == ["mailer@clientela.com.br"]
      end

      it "should have to" do
        @email.to.should == [@task.assigned_to.email]
      end

      it "should have subject" do
        @email.subject.should == "[Tarefa] blas"
      end

      it "should have right body" do
        @email.body.to_s.should == read_custom_fixture("task_notification")
      end
    end

    describe "task associated to a contact" do
      it "should have right body" do
        task = FactoryGirl.create(:task_pending, taskable: FactoryGirl.create(:contact_quentin, id: "99999", emails: [FactoryGirl.create(:email)], phones: [FactoryGirl.create(:phone)]))
        UserMailer.task_notification(task).body.to_s.should == read_custom_fixture("task_notification_with_associated_contact")
      end
    end

    describe "task associated to a company" do
      it "should have right body" do
        task = FactoryGirl.create(:task_yesterday_done, taskable: FactoryGirl.create(:company_helabs, id: "99999"))
        UserMailer.task_notification(task).body.to_s.should == read_custom_fixture("task_notification_with_associated_company")
      end
    end

    describe "task associated to a deal" do
      it "should have right body" do
        task = FactoryGirl.create(:task_tomorrow, taskable: FactoryGirl.create(:quentin_deal_won, id: "99999"))
        UserMailer.task_notification(task).body.to_s.should == read_custom_fixture("task_notification_with_associated_deal")
      end
    end

    describe "task associated to a fact" do
      it "should have right body" do
        task = FactoryGirl.create(:task_tomorrow_done, taskable: FactoryGirl.create(:fact, id: "99999"))
        UserMailer.task_notification(task).body.to_s.should == read_custom_fixture("task_notification_with_associated_fact")
      end
    end
  end

  describe "we_are_missing_you" do
    before(:each) do
      @user = user
      @email = UserMailer.we_are_missing_you(@user)
    end

    it "should have from" do
      @email.header['From'].to_s.should == "Clientela <contato@clientela.com.br>"
    end

    it "should have to" do
      @email.header['To'].to_s.should == "Quentin Tarantino <#{@user.email}>"
    end

    it "should have subject" do
      @email.subject.should == "[Clientela] Sentimos a sua falta. Podemos ajudar?"
    end

    it "should set correct body for text html" do
      @email.body.to_s.should == read_mail('we_are_missing_you')
    end

    it "should set correct content type" do
      @email.content_type.should == "text/html; charset=UTF-8"
    end
  end

  describe "your_account_was_disabled" do
    before(:each) do
      @user = user
      @email = UserMailer.your_account_was_disabled(@user)
    end

    it "should have from" do
      @email.header['From'].to_s.should == "Clientela <contato@clientela.com.br>"
    end

    it "should have to" do
      @email.header['To'].to_s.should == "Quentin Tarantino <#{@user.email}>"
    end

    it "should have subject" do
      @email.subject.should == "[Clientela] Sua conta foi bloqueada. Podemos ajudar?"
    end

    it "should set correct body for text html" do
      @email.body.to_s.should == read_mail('your_account_was_disabled')
    end

    it "should set correct content type" do
      @email.content_type.should == "text/html; charset=UTF-8"
    end

  end

  describe "your_account_was_locked" do
    before(:each) do
      @user = user
      @email = UserMailer.your_account_was_locked(@user)
    end

    it "should have from" do
      @email.header['From'].to_s.should == "Clientela <contato@clientela.com.br>"
    end

    it "should have to" do
      @email.header['To'].to_s.should == "Quentin Tarantino <#{user.email}>"
    end

    it "should have subject" do
      @email.subject.should == "[Clientela] Sua conta foi bloqueada. Podemos ajudar?"
    end

    it "should set correct body for text html" do
      @email.body.to_s.should == read_mail('your_account_was_locked')
    end

    it "should set correct content type" do
      @email.content_type.should == "text/html; charset=UTF-8"
    end
  end

  describe "satisfaction_survey_first_week" do
    before(:each) do
      @user = user
      @account = account
      @account.stub(:domain).and_return("dominio")
      @user.stub(:email).and_return("email4@example.com")
      @email = UserMailer.satisfaction_survey_first_week(@user, account)
    end

    it "should have from" do
      @email.header['From'].to_s.should == "Clientela <contato@clientela.com.br>"
    end

    it "should have to" do
      @email.header['To'].to_s.should == "Quentin Tarantino <#{@user.email}>"
    end

    it "should have subject" do
      @email.subject.should == "[Clientela] O que você está achando do Clientela?"
    end

    it "should set correct body for text html" do
      @email.body.to_s.should == read_mail('satisfaction_survey_first_week')
    end

    it "should set correct content type" do
      @email.content_type.should == "text/html; charset=UTF-8"
    end
  end

  describe "fwd_misuse" do
    before(:each) do
      @user = user
      @email = UserMailer.fwd_misuse(@user, 'Original e-mail subject')
    end

    it "should have from" do
      @email.header['From'].to_s.should == "Clientela <contato@clientela.com.br>"
    end

    it "should have to" do
      @email.header['To'].to_s.should == "Quentin Tarantino <#{@user.email}>"
    end

    it "should have subject" do
      @email.subject.should == "Re: Original e-mail subject"
    end

    it "should set correct body for text html" do
      @email.body.to_s.should == read_mail('fwd_misuse')
    end

    it "should set correct content type" do
      @email.content_type.should == "text/html; charset=UTF-8"
    end
  end

  private
  def read_mail(name)
    filename = Rails.root.join('spec','fixtures','user_mailer',"#{name}.html")
    File.open(filename, 'w') {|f| f.write(@email.body) } unless File.exists?(filename)
    File.read(filename)
  end
  
  def read_custom_fixture(action)
    ERB.new(IO.readlines("#{File.dirname(__FILE__) + "/../fixtures"}/user_mailer/#{action}").join('')).result(binding)
  end
end
