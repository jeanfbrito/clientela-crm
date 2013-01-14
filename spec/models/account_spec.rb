# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do

  describe "validations" do
    context "presence" do
      should_validate_presence_of :name 
    end
    context "uniqueness" do
      before do
        a = FactoryGirl.create(:example)
      end
      should_validate_uniqueness_of :domain 
    end
  end

  describe "scope active" do
    let!(:example) { FactoryGirl.create(:example) }
    let!(:dummy) { FactoryGirl.create(:dummy) }
    it "should not return deactivated accounts" do
      Account.active.sort_by(&:name).should include(example, dummy)
    end
  end

  describe "scope inactive" do
    let!(:other) { FactoryGirl.create(:other) }

    it "should return deactivated accounts older than 1 month" do
      Account.inactive.should == [other]
    end
  end

  describe "deactivate" do
    let!(:admin) { FactoryGirl.create(:admin) }
    before(:each) do
      @deactivate = FactoryGirl.create(:example)
      Account.stub!(:find).and_return(@deactivate)
    end

    after(:each) do
      @deactivate.update_attribute(:active, true)
    end

    def sent_email
      ActionMailer::Base.deliveries.last
    end

    def deliveries
      ActionMailer::Base.deliveries
    end

    def deactivate!(kind)
      Account.deactivate(@deactivate.id, kind)
    end

    context "by locking" do
      it "should deactivate the account" do
        lambda do
          deactivate!(:lock)
        end.should change(@deactivate, :active).from(true).to(false)
      end

      describe "email notification" do
        it "should notify by e-mail" do
          lambda do
            deactivate!(:lock)
          end.should change(deliveries, :size).by(1)
        end

        it "should notify quentin" do
          deactivate!(:lock)
          sent_email.to.should == [admin.email]
        end

        it "should send correct email" do
          deactivate!(:lock)
          sent_email.subject.should =~ /Sua conta foi bloqueada. Podemos ajudar/
          sent_email.body.should =~ /nosso sistema não identificou o pagamento da última/
        end
      end
    end

    context "by disabling" do
      it "should deactivate the account" do
        lambda do
          deactivate!(:disable)
        end.should change(@deactivate, :active).from(true).to(false)
      end

      describe "email notification" do
        it "should notify by e-mail" do
          lambda do
            deactivate!(:disable)
          end.should change(deliveries, :size).by(1)
        end

        it "should notify quentin" do
          deactivate!(:disable)
          sent_email.to.should == [admin.email]
        end

        it "should send correct email" do
          deactivate!(:disable)
          sent_email.subject.should =~ /Sua conta foi bloqueada. Podemos ajudar/
          sent_email.body.should =~ /Sua conta foi bloqueada, pois houve suspeita de abuso dos/
        end
      end
    end
  end

  describe "activate" do
    before(:each) do
      @activate = FactoryGirl.create(:deactivated)
    end

    it "should deactivate the account" do
      Account.activate(@activate.id)
      Account.find(@activate.id).active.should == true
    end
  end

  describe "admin_user" do
    let!(:example) { FactoryGirl.create(:example) }
    let!(:admin) { FactoryGirl.create(:admin) }

    describe ".admin_name" do
      it "returns admin name" do
        example.admin_name.should == admin.name
      end
    end

    describe ".admin_email" do
      it "returns admin email" do
        example.admin_email.should == admin.email
      end
    end
  end

  describe "destroy_inactive" do
    let(:account) { FactoryGirl.create(:example) }

    before(:each) do
      account.should_receive(:destroy)
      Account.should_receive(:inactive).and_return([account])
    end

    it "should delete inactive accounts" do
      Account.destroy_inactive
    end
  end

  describe "find_current" do
    before(:each) do
      @account = FactoryGirl.create(:example)
      Account.should_receive(:first).and_return(@account)

      @return = Account.find_current
    end

    it "should find account by id, configure! it and return itself" do
      @return.should == @account
    end

    it "should set Account.current" do
      Account.current.should == @account
    end
  end

  describe "configure_by_domain" do
    before(:each) do
      @account = FactoryGirl.create(:example)
      Account.should_receive(:find_by_domain!).with('example').and_return(@account)

      @return = Account.configure_by_domain('example')
    end

    it "should find account by domain, configure! it and return itself" do
      @return.should == @account
    end

    it "should set Account.current" do
      Account.current.should == @account
    end
  end

  describe ".create user" do
    before(:each) do
      @account = FactoryGirl.create(:example)
    end

    it "creates a user inside account" do
      expect {
        @account.create_user(user_params).should be_true
      }.to change(User, :count).by(1)
    end

    it "assigns the correct email" do
      @account.create_user(user_params)
      User.last.email.should == "johnny@example.com"
    end

    it "creates an admin_user" do
      @account.create_user(user_params)
      User.last.should be_admin
    end

    def user_params
      {:name => "Johnny", :email => "johnny@example.com", :password => 'teste123', :password_confirmation => 'teste123'}
    end
  end 

  describe "validates domain" do
    describe "valid" do
      [
        "mydomain",
        "mydomain1",
        "1mydomain1",
      ].each do |name|
        it "should accept #{name} as domain" do
          Account.new(:name => 'new account', :domain => name).should be_valid
        end
      end
    end

    describe "invalid" do
      [
        "mydomain1-",
        "my domain",
        "my.domain",
        "Mydomain",
        "domaingreaterthan15chars",
        ""
      ].each do |name|
        it "should not accept #{name} as domain" do
          create_and_validate_account(name, "contém apenas letras minúsculas e números e tem entre 1 e 15 caracteres")
        end
      end

      [
        "www",
        "smtp",
        "ftp",
        "ssh",
        "mail",
        "pop",
        "app",
        "resque"
      ].each do |name|
        it "should not accept #{name} as domain" do
          create_and_validate_account(name, "não está disponível")
        end
      end

      def create_and_validate_account(name, error)
        account = Account.new(:name => 'new account', :domain => name)
        account.should be_invalid
        account.errors[:domain].should == [error]
      end
    end
  end

  def account_params_with_user(options = {})
    {:name => 'accountname', :domain => ActiveSupport::SecureRandom.hex(5)}.merge(options)
  end
end
