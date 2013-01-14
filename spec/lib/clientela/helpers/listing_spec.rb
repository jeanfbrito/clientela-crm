require File.dirname(__FILE__) + '/../../../spec_helper'

describe Clientela::Helpers::Listing do
  describe "initialize" do
    before(:each) do
      @listing = Clientela::Helpers::Listing.new(:body => "body")
    end

    it "should initialize :records" do
      @listing.instance_variable_get(:@body).should == "body"
    end
  end

  describe "to_s" do
    it "should render table with class listing and body" do
      Clientela::Helpers::Listing.new({:body => "a"}).to_s.should == %{<table class="listing"><tbody>a</tbody></table>}
    end
  end
end