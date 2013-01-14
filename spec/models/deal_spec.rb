require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Deal do
  should_validate_presence_of :name
  should_validate_inclusion_of :status, :in => %w(prospect qualify proposal negotiation won lost)

  should_validate_presence_of :value
  should_validate_inclusion_of :value_type, :in => %w(fixed hourly monthly yearly), :allow_nil => true
  should_validate_inclusion_of :probability, :in => 0..100
  should_validate_presence_of :assigned_to

  should_belong_to :assigned_to, :class_name => "User"
  should_have_many :permissions, :dependent => :destroy
  should_have_many :groups, :through => :permissions
  should_have_many :notes, :dependent => :destroy, :as => :notable
  should_have_many :tasks, :dependent => :destroy, :as => :taskable
  should_have_many :relationships, :dependent => :destroy, :as => :entity
  should_have_many :contacts, :through => :relationships
  should_have_many :subscriptions, :dependent => :destroy
  should_have_many :subscribers, :through => :subscriptions, :class_name => "User"

  it { Deal.pending.to_sql.should == %{SELECT "deals".* FROM "deals" WHERE (status NOT IN ('won','lost'))} }

  Deal.statuses.each do |status|
    it { Deal.send(status).to_sql.should == %{SELECT "deals".* FROM "deals" WHERE "deals"."status" = '#{status}'} }
  end

  describe "status scopes" do
    xit "prospect"
    xit "qualify"
    xit "proposal"
    xit "negotiation"
    xit "won"
    xit "lost"
  end

  describe "passing contact_name on create" do
    before(:each) do
      account = mock_model(Account, :id => '42')
      Account.stub(:current).and_return(account)
    end

    context "when deal is invalid" do
      it "should save contact_name on returned object" do
        deal = Deal.new(default_params.merge(:contact_name => "This Contact Name", :name => nil))
        deal.save.should be_false
        deal.contact_name.should == "This Contact Name"
      end
    end

    context "when contact_name is blank" do
      def create_deal_with_blank_contact_name
        @deal = Deal.create!(default_params.merge(:contact_name => ""))
      end

      it "should not create a new contact" do
        lambda do
          create_deal_with_blank_contact_name
        end.should_not change(Contact, :count)
      end

      it "should not create a relashionship" do
        create_deal_with_blank_contact_name
        @deal.contacts.should be_empty
      end
    end

    context "when contact_name exists as a contact" do
      let!(:contact) { FactoryGirl.create(:contact_joseph) }
      def create_deal_with_existing_contact_name
        @deal = Deal.create!(default_params.merge(:contact_name => "Joseph"))
      end

      it "should not create a new contact" do
        lambda do
          create_deal_with_existing_contact_name
        end.should_not change(Contact, :count)
      end

      it "should add relashionship with the existing contact" do
        create_deal_with_existing_contact_name
        @deal.contacts.should include(contact)
      end
    end

    context "when contact_name doesn't exists as a contact" do
      before do
        @group = Group.create!(:name => "Quentin")
        @group.users << FactoryGirl.create(:quentin)
      end

      def deal_contact_name
        "New Contact Name"
      end

      def create_deal_with_new_contact_name
        @deal = Deal.create!(default_params.
          merge(:contact_name => deal_contact_name).
          merge(:permissions_attributes => {
            "0" => {"group_id" => @group.id, "_destroy" => "0"}
          })
        )
      end

      it "should set permissions to deal" do
        create_deal_with_new_contact_name
        @deal.reload
        @deal.permissions.map(&:group).should == [@group]
      end

      it "should set permissions to contact" do
        create_deal_with_new_contact_name
        Contact.find_by_name(deal_contact_name).permissions.map(&:group).should == [@group]
      end

      it "should create the new contact" do
        lambda do
          create_deal_with_new_contact_name
        end.should change(Contact, :count).by(1)
      end

      it "should add relashionship with the new contact" do
        create_deal_with_new_contact_name
        @deal.contacts.should include(Contact.find_by_name(deal_contact_name))
      end
    end
  end

  describe "value types" do
    it "should return value types" do
      Deal.value_types.should == %w(fixed hourly monthly yearly)
    end
  end

  describe "statuses" do
    it "should return statuses" do
      Deal.statuses.should == %w(prospect qualify proposal negotiation lost won)
    end
  end

  describe "automagically update of probability" do
    before(:each) do
      @deal = FactoryGirl.create(:quentin_deal_pending)
    end

    context "when deal is marked as won" do
      it "should be updated to 100" do
        lambda do
          @deal.update_attributes(:status => 'won')
        end.should change(@deal, :probability).from(50).to(100)
      end
    end

    context "when deal is marked as lost" do
      it "should be updated to 0" do
        lambda do
          @deal.update_attributes(:status => 'lost')
        end.should change(@deal, :probability).from(50).to(0)
      end
    end

    context "when deal is marked as any other" do
      it "should not change" do
        lambda do
          @deal.update_attributes(:status => 'negotiation')
        end.should_not change(@deal, :probability)
      end
    end
  end

  describe "created_between" do
    it "should return deals created on 31th day" do
      [:quentin_deal_lost, :quentin_deal_pending].each do |deal|
        FactoryGirl.create(deal.to_sym)
      end
      from_date = Date.new(2011, 8, 1)
      to_date   = Date.new(2011, 8, 31)
      Deal.created_between(from_date, to_date).to_sql.should == %{SELECT "deals".* FROM "deals" WHERE (created_at BETWEEN '2011-08-01 00:00:00.000000' AND '2011-08-31 23:59:59.999999')}
      Deal.created_between(from_date, to_date).count.should == 2
    end
  end

  describe "won_at" do
    it "should create right sql" do
      from_date = Date.new(2011, 10, 1)
      to_date = Date.new(2011, 10, -1)
      Deal.won_between(from_date, to_date).to_sql.should == %{SELECT "deals".* FROM "deals" WHERE "deals"."status" = 'won' AND (status_last_change_at BETWEEN '2011-10-01 00:00:00.000000' AND '2011-10-31 23:59:59.999999')}
    end
  end

  describe "update status_last_change_at" do
    before(:each) do
      @deal = FactoryGirl.create(:quentin_deal_pending)
    end

    context "when a new deal is created" do
      it "should set status_last_change_at" do
        deal = Deal.create!(default_params)
        deal.status_last_change_at.should_not be_nil
      end
    end

    context "when status is updated" do
      it "should update status_last_change_at" do
        @deal.status = "won"
        lambda do
          @deal.save!
        end.should change(@deal, :status_last_change_at)
      end
    end

    context "when status is not updated" do
      it "should not update status_last_change_at" do
        @deal.name = "new deal name"
        lambda do
          @deal.save!
        end.should_not change(@deal, :status_last_change_at)
      end
    end
  end

  describe 'total value' do
    it 'should return value * duration if duration is present' do
      deal = FactoryGirl.create(:quentin_deal_won)
      deal.total_value.should == deal.value * deal.duration
    end

    it 'should return value if duration is not present' do
      deal = FactoryGirl.create(:quentin_deal_pending)
      deal.total_value.should == deal.value
    end
  end

  describe "total" do
    before do
      [:quentin_deal_won, :quentin_deal_lost, :quentin_deal_pending, :quentin_0_0, :quentin_0_1, :quentin_0_2].each do |deal|
        FactoryGirl.create(deal.to_sym)
      end
    end

    it "should have total on pending" do
      Deal.pending.total.should == 10
    end

    it "should have total on lost" do
      Deal.lost.total.should == 3711
    end

    it "should have total on won" do
      Deal.won.total.should == 458402
    end
  end

  describe "report_values" do
    it "should return notify_values kinds" do
      Deal.report_values.should == [:week, :month, :year]
    end
  end

  describe "by date" do
    [:quentin_deal_won, :quentin_deal_lost, :quentin_deal_pending, :quentin_0_0, :quentin_0_1, :quentin_0_2,
     :quentin_1_0, :quentin_1_1, :quentin_1_2, :quentin_3_0, :quentin_3_1, :quentin_3_2, :quentin_5_0, :quentin_5_1, :quentin_5_2,
     :quentin_7_0, :quentin_7_1, :quentin_7_2, :quentin_9_0, :quentin_9_1, :quentin_9_2, :quentin_11_0, :quentin_11_1, :quentin_11_2].each do |deal|
      let!(deal.to_sym) { FactoryGirl.create(deal.to_sym) }
    end

    describe "quantitative data" do
      context "by year" do
        it "should return correct values from 2011" do
          Deal.quantitative_data(2011, 20).should == [["", 0, 0, 20], ["Jan", 0, 0, 20], ["Fev", 3, 0, 20], ["Mar", 0, 0, 20], ["Abr", 3, 0, 20], ["Mai", 0, 0, 20], ["Jun", 3, 0, 20], ["Jul", 3, 0, 20], ["Ago", 2, 0, 20], ["Set", 1, 0, 20], ["Out", 0, 0, 20], ["Nov", 0, 0, 20], ["Dez", 0, 0, 20], ["", 0, 0, 20]]
        end

        it "should return correct values from 2010" do
          Deal.quantitative_data(2010, 10).should == [["", 0, 0, 10], ["Jan", 0, 0, 10], ["Fev", 0, 0, 10], ["Mar", 0, 0, 10], ["Abr", 0, 0, 10], ["Mai", 0, 0, 10], ["Jun", 0, 0, 10], ["Jul", 0, 0, 10], ["Ago", 3, 0, 10], ["Set", 0, 0, 10], ["Out", 3, 0, 10], ["Nov", 0, 0, 10], ["Dez", 3, 0, 10], ["", 0, 0, 10]]
        end
      end
    end

    describe "qualitative data" do
      context "by year" do
        it "should return correct values from 2011" do
          Deal.qualitative_data(2011, 20).should == [["", 0, 0, 20], ["Jan", 0, 0, 20], ["Fev", 772233, 0, 20], ["Mar", 0, 0, 20], ["Abr", 655755, 0, 20], ["Mai", 0, 0, 20], ["Jun", 664403, 0, 20], ["Jul", 452103, 0, 20], ["Ago", 20, 0, 20], ["Set", 10000, 0, 20], ["Out", 0, 0, 20], ["Nov", 0, 0, 20], ["Dez", 0, 0, 20], ["", 0, 0, 20]]
        end

        it "should return correct values from 2010" do
          Deal.qualitative_data(2010, 10).should == [["", 0, 0, 10], ["Jan", 0, 0, 10], ["Fev", 0, 0, 10], ["Mar", 0, 0, 10], ["Abr", 0, 0, 10], ["Mai", 0, 0, 10], ["Jun", 0, 0, 10], ["Jul", 0, 0, 10], ["Ago", 487243, 0, 10], ["Set", 0, 0, 10], ["Out", 1022706, 0, 10], ["Nov", 0, 0, 10], ["Dez", 1104354, 0, 10], ["", 0, 0, 10]]
        end
      end
    end
  end

  def default_params
    {:name => "deal name", :value => 10, :assigned_to_id => FactoryGirl.create(:quentin).id}
  end
end
