require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Address do
  should_validate_inclusion_of :kind, :in => ["work", "home", "other", "headquarters", "subsidiary", "office", "other"], :allow_blank => false

  describe "kinds" do
    it "should return address kinds for contact" do
      Address.kinds_for(Contact.new).should == ["work", "home", "other"]
    end

    it "should return address kinds for company" do
      Address.kinds_for(Company.new).should == ["headquarters", "subsidiary", "office", "other"]
    end
  end

  describe "line 1" do
    before(:each) do
      @street = "This is My Street, 26"
    end

    it "should return street as line1" do
      Address.new(:street => @street).line1.should == @street
    end

    it "should return empty when no street" do
      Address.new().line1.should be_blank
    end
  end

  describe "line 2" do
    it "should concat city, state and zip with coma" do
      Address.new(:city => "Rio", :state => "RJ", :zip => "123").line2.should == "Rio, RJ, 123"
    end

    it "should ignore city" do
      Address.new(:state => "RJ", :zip => "123").line2.should == "RJ, 123"
    end

    it "should ignore state" do
      Address.new(:city => "Rio", :zip => "123").line2.should == "Rio, 123"
    end

    it "should ignore zip" do
      Address.new(:city => "Rio", :state => "RJ").line2.should == "Rio, RJ"
    end

    it "should return empty when no city, state or zip" do
      Address.new().line1.should be_blank
    end
  end

  describe "map_link" do
    it "should return google maps link" do
      Address.new(:street => "my street, 26",:city => "Rio", :state => "RJ", :zip => "123").map_link.should == "http://maps.google.com/maps?q=my+street%2C+26%2C+Rio%2C+RJ%2C+123"
    end
  end
end
