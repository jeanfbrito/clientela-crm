require File.dirname(__FILE__) + '/../../../spec_helper'

describe Clientela::Helpers::TipBox do
  describe "initialize" do
    before(:each) do
      @tip_box = Clientela::Helpers::TipBox.new(:header => "header", :body => "body")
    end

    it "should initialize @body" do
      @tip_box.instance_variable_get(:@body).should == "body"
    end

    it "should initialize @header" do
      @tip_box.instance_variable_get(:@header).should == "header"
    end
  end

  describe "to_s" do
    it "should render tip box" do
      Clientela::Helpers::TipBox.new(:header => "header", :body => "body").to_s.should == %{<div class="tip-box"><h1>header</h1>body</div>}
    end
  end
end