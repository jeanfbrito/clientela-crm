require File.dirname(__FILE__) + '/../../../spec_helper'

describe Clientela::Helpers::ContentBox do
  describe "initialize" do
    before(:each) do
      @box = Clientela::Helpers::ContentBox.new(:header => "header", :span => "span", :body => "body", :id => "id")
    end

    it "should initialize :inner_header" do
      @box.instance_variable_get(:@inner_header).should be_instance_of(Clientela::Helpers::InnerHeader)
    end

    it "should initialize :body" do
      @box.instance_variable_get(:@body).should == "body"
    end

    it "should initialize :id" do
      @box.instance_variable_get(:@id).should == "id"
    end
  end
  
  describe "to_s" do
    before(:each) do
      Clientela::Helpers::InnerHeader.should_receive(:new).with(:header => "header", :span => "span").and_return("<inner_header/>")
    end
    
    it "should render with id" do
      box = Clientela::Helpers::ContentBox.new(:header => "header", :span => "span", :body => "body", :id => "id")
      box.to_s.should == %{<inner_header/><div id="id">body</div>}
    end
    
    it "should render without id" do
      box = Clientela::Helpers::ContentBox.new(:header => "header", :span => "span", :body => "body")
      box.to_s.should == %{<inner_header/><div id="main_content">body</div>}
    end
  end
end