require File.dirname(__FILE__) + '/../../../spec_helper'

describe Clientela::Helpers::InnerHeader do
  describe "initialize" do
    before(:each) do
      @header = Clientela::Helpers::InnerHeader.new(:header => "header", :span => "span")
    end

    it "should initialize :header" do
      @header.instance_variable_get(:@header).should == "header"
    end

    it "should initialize :span" do
      @header.instance_variable_get(:@span).should == "span"
    end
  end
  
  describe "to_s" do
    it "should render with no span" do
      Clientela::Helpers::InnerHeader.new(:header => "header").to_s.should == %{<div class="inner_header"><h1>header</h1></div>}
    end
    
    it "should render with span" do
      Clientela::Helpers::InnerHeader.new(:header => "header", :span => "<a href='#'>span</a>").to_s.should == %{<div class="inner_header"><h1>header</h1><span><a href='#'>span</a></span></div>}
    end
  end
end