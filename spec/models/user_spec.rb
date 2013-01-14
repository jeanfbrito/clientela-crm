require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  should_have_many :activities, :foreign_key => :author_id, :dependent => :nullify
  should_have_many :tasks, :foreign_key => :assigned_to_id, :dependent => :destroy
  should_have_many :deals, :foreign_key => :assigned_to_id, :dependent => :nullify
  should_have_and_belong_to_many :groups

  should_validate_presence_of :name

  let!(:user) { FactoryGirl.create(:quentin) }
  let!(:fake) { FactoryGirl.create(:fake) }

  it { User.active.to_sql.should == %{SELECT "users".* FROM "users" WHERE "users"."invitation_token" IS NULL ORDER BY name} }

  describe "after create" do
    it "should create individual group" do
      expect {
        User.create!(:name => "new cl user", :email => "new@user.com", :password => "123456")
      }.to change(Group, :count).by(1)
    end
    context "regular" do
      let(:user) { User.create!(:name => "new cl user", :email => "new@user.com", :password => "123456") }
      subject { user.groups.first }

      its(:individual) { should be_true }
      its(:name) { should == "new cl user" }
      its(:users) { should == [user] }
      its(:permissions) { should == [] }
    end
  end

  describe "notify_satisfaction_survey" do
    before(:each) do
      account = FactoryGirl.create(:example)
      account.should_receive(:configure!)
      Account.should_receive(:active).and_return([account])

      ActionMailer::Base.deliveries = []
      User.should_receive(:notifiable_satisfaction_survey_users).and_return([user])
      User.notify_satisfaction_survey
    end

    it "should notify by email" do
      ActionMailer::Base.deliveries.count.should == 1
    end

    it "should update we_are_missing_you_notified survey to true" do
      user.survey[:satisfaction_survey].should be_true
    end
  end

  describe "notify_we_are_missing_you" do
    before(:each) do
      account = FactoryGirl.create(:example)
      account.should_receive(:configure!)
      Account.should_receive(:active).and_return([account])

      ActionMailer::Base.deliveries = []
      User.should_receive(:notifiable_we_are_missing_you_users).and_return([user])
      User.notify_we_are_missing_you
    end

    it "should notify by email" do
      ActionMailer::Base.deliveries.count.should == 1
    end

    it "should update we_are_missing_you_notified survey to true" do
      user.survey[:we_are_missing_you_notified].should be_true
    end
  end

  describe "notifiable_satisfaction_survey_users" do
    before(:each) do
      user.update_attribute(:created_at, (1.weeks.ago - 1.day))
      fake.update_attribute(:created_at, (1.weeks.ago - 1.day))
    end

    it "should return users with created_at more than 1 week and survey satisfaction_survey not filled" do
      User.notifiable_satisfaction_survey_users.should == [user, fake]
    end

    it "should not return users with survey satisfaction_survey filled" do
      user.update_survey(:satisfaction_survey => true)
      User.notifiable_satisfaction_survey_users.should == [fake]
    end

    it "should not return users with created_at until 1 week" do
      user.update_attribute(:created_at, (3.days.ago))
      User.notifiable_satisfaction_survey_users.should == [fake]
    end
  end

  describe "notifiable_we_are_missing_you_users" do
    it "should return users with current_sign_in_at NULL and created_at older than 2 weeks" do
      user.update_attribute(:created_at, (2.weeks.ago-1.day))
      User.notifiable_we_are_missing_you_users.should == [user]
    end

    it "should return users with current_sign_in_at older than 2 weeks and created_at older than 2 weeks" do
      user.update_attribute(:current_sign_in_at, (2.weeks.ago - 1.day))
      user.update_attribute(:created_at, (2.weeks.ago-1.day))
      User.notifiable_we_are_missing_you_users.should == [user]
    end

    it "should not return user with current_sign_in_at newer than 2 weeks and created_at older than 2 weeks" do
      user.update_attribute(:current_sign_in_at, (2.weeks.ago + 1.day))
      user.update_attribute(:created_at, (2.weeks.ago-1.day))

      fake.update_attribute(:current_sign_in_at, (2.weeks.ago - 1.day))
      fake.update_attribute(:created_at, (2.weeks.ago-1.day))

      User.notifiable_we_are_missing_you_users.should == [fake]
    end

    it "should not notify an user 2 times" do
      user.update_survey(:we_are_missing_you_notified => true)

      fake.update_attribute(:current_sign_in_at, (2.weeks.ago - 1.day))
      fake.update_attribute(:created_at, (2.weeks.ago-1.day))

      User.notifiable_we_are_missing_you_users.should == [fake]
    end
  end

  describe "update_survey" do
    before(:each) do
      @user = user
    end

    def update_user_with(params)
      @user.update_survey(params)
      @user.reload
    end

    context "when user hash is empty" do
      it "should save survey" do
        update_user_with(:cachorro => "mingau")
        @user.survey.should == {:cachorro=>"mingau"}
      end
    end

    context "when user hash is already filled" do
      it "should update current hash" do
        update_user_with(:cachorro => "mingau")
        update_user_with(:vaca => "capim")

        @user.survey.should == {:cachorro=>"mingau", :vaca=>"capim"}
      end
    end
  end

  describe "survey" do
    context "when null" do
      it "should return an empty hash" do
        user.survey.should == {}
      end
    end

    context "when empty" do
      it "should return an empty hash" do
        user.survey.should == {}
      end
    end

  end

  describe "active_for_authentication?" do
    it "should delegate to current account" do
      Account.current = mock(:active? => true)
      user.active_for_authentication?.should be_true
    end
  end

  describe "authentication_token" do
    it "should generate token on create" do
      create_user.authentication_token.should_not be_nil
    end
  end

  describe "dropbox_token" do
    it "should generate token on create" do
      create_user.dropbox_token.should_not be_nil
    end

    it "should change dropbox token" do
      lambda do
        user.reset_dropbox_token!
        user.reload
      end.should change(user, :dropbox_token)
    end
  end

  describe "we should notify user about his new account" do
    it "should not notify by mail if admin" do
      lambda do
        user = User.new(:name => "Johnny", :email => "mail@example.com", :password => "myworstpass")
        user.admin = true
        user.save!
      end.should change(ActionMailer::Base.deliveries, :size).by(0)
    end
  end

  def create_user
    User.create!(user_params)
  end

  def user_params
    {:name => "Deepy", :password => "thisishard", :email => "email@deepy.com"}
  end

  describe "to_xml" do
    [:encrypted_password, :remember_token, :reset_password_token, :welcome].each do |attr|
      it "should not include #{attr} in xml" do
        user.to_xml.should_not include(attr.to_s.dasherize)
      end
    end
  end

  describe "update_attributes_with_password_ignore" do
    before(:each) do
      @user = user
    end

    it "should clean up password fields" do
      @user.update_attributes_with_password_ignore(:password => "abc", :password_confirmation => "cde")
      @user.password.should be_blank
      @user.password_confirmation.should be_blank
    end

    it "should ignore if password and password_confirmation come blank" do
      @user.update_attributes_with_password_ignore(:name => "new name", :password => "", :password_confirmation => "").should be_true
      @user.name.should == "new name"
    end
  end

  describe "abilities" do
    before do
      @group = Group.create!(:name => "My group")

      @other_user = fake

      @user = user
      @user.groups << @group

      @contact = FactoryGirl.create(:contact_joseph, imported_by: nil)
      @contact.permissions.create!(:group => @group)

      @deal = FactoryGirl.create(:quentin_deal_won)
      @deal.permissions.create!(:group => @group)

      @other_contact = FactoryGirl.create(:entity_quentin)
      @other_deal = FactoryGirl.create(:quentin_deal_lost)
      @new_contact = Contact.new
      @new_deal = Deal.new
    end

    subject { ability }

    context "user" do
      let(:ability){ Ability.new(@user) }
      it{ should be_able_to(:manage, @contact) }
      it{ should_not be_able_to(:manage, @other_contact) }
      it{ should_not be_able_to(:manage, @new_contact) }

      it{ should be_able_to(:manage, @deal) }
      it{ should_not be_able_to(:manage, @other_deal) }
      it{ should_not be_able_to(:manage, @new_deal) }
    end
    context "other user" do
      let(:ability){ Ability.new(@other_user) }
      it{ should_not be_able_to(:manage, @contact) }
      it{ should_not be_able_to(:manage, @other_contact) }
      it{ should_not be_able_to(:manage, @new_contact) }

      it{ should_not be_able_to(:manage, @deal) }
      it{ should_not be_able_to(:manage, @other_deal) }
      it{ should_not be_able_to(:manage, @new_deal) }
    end
  end
end
