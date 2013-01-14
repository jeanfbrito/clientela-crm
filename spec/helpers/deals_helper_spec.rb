require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DealsHelper do
  describe "checked" do
    before(:each) do
      @deal = mock(:status => :won)
    end

    it "should return checked" do
      helper.checked(@deal, "won").should == "checked"
    end

    it "should return nothing" do
      helper.checked(@deal, "lost").should == nil
    end
  end

  describe "formated_bid" do
    it "should display none when no value" do
      deal = mock(:value => nil, :value_type => nil)
      helper.formated_bid(deal).should be_nil
    end

    it "should format when fixed bid" do
      deal = mock(:value => 10, :value_type => "fixed", :duration => nil)
      helper.formated_bid(deal).should == "<p>R$ 10,00 valor fixo</p>"
    end

    it "should format when per hour bid" do
      deal = mock(:value => 10, :value_type => "hourly", :duration => 10)
      helper.formated_bid(deal).should == "<p>R$ 100,00 por 10 horas cobrando R$ 10,00/hora</p>"
    end

    it "should format when per hour bid" do
      deal = mock(:value => 10, :value_type => "hourly", :duration => 10)
      helper.formated_bid(deal).should == "<p>R$ 100,00 por 10 horas cobrando R$ 10,00/hora</p>"
    end

    it "should format when per month bid" do
      deal = mock(:value => 10, :value_type => "monthly", :duration => 10)
      helper.formated_bid(deal).should == "<p>R$ 100,00 por 10 meses cobrando R$ 10,00/mes</p>"
    end

    it "should format when per year bid" do
      deal = mock(:value => 10, :value_type => "yearly", :duration => 10)
      helper.formated_bid(deal).should == "<p>R$ 100,00 por 10 anos cobrando R$ 10,00/ano</p>"
    end
  end
end
