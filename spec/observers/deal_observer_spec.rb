require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DealObserver do
  let!(:deal) { FactoryGirl.create(:quentin_deal_won) }
  it "should create new activity on create" do
    record = {:name => deal.name, :type => "deal", :id => deal.id}
    Activity.should_receive(:create).with(:activitable => deal, :action => "create", :record => record )
    @obs = DealObserver.instance
    @obs.after_create(deal)
  end  

  it "should not create new activity when editing something else than status" do
    lambda do
      deal.update_attributes(:name => "Novo Nome")
    end.should_not change(Activity, :count)
  end

  describe "when changing status" do
    def mock_deal(stubs={})
      @mock_deal ||= mock_model(Contact, {:status_changed? => true, :name => "Deal name", :id => 6}.merge(stubs))
    end

    before(:each) do
      @record = {:name => "Deal name", :type => "deal", :id => 6}
    end

    after(:each) do
      @obs = DealObserver.instance
      @obs.before_update(mock_deal)
    end

    it 'should create new activity from lost to won' do      
      mock_deal(:status => "won")
      Activity.should_receive(:create).with(:activitable => mock_deal, :action => :won, :record => @record)
    end

    it 'should create new activity from won to lost' do
      mock_deal(:status => "lost")
      Activity.should_receive(:create).with(:activitable => mock_deal, :action => :lost, :record => @record)
    end

    it 'should create new activity from won to pending' do
      mock_deal(:status => "pending")
      Activity.should_receive(:create).with(:activitable => mock_deal, :action => :pending, :record => @record)
    end
  end

  it "should create activity when deleting deal" do
    deal = mock_model(Deal, :name => "fulano", :type => "deal", :id => 42)
    record = {:name => deal.name, :type => "deal", :id => deal.id}
    Activity.should_receive(:create).with(:activitable => deal, :action => "destroy", :record => record )
    @obs = DealObserver.instance
    @obs.after_destroy(deal)
  end
end