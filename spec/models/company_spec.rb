require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Company do
  should_have_many :contacts

  it "should create company when company_name is not blank" do
    lambda do
      Contact.create!(:name => "Chuck Norris", :company_name => "Texas Ranger")
    end.should change(Company, :count).by(1)
  end

  it "should not create company when company_name is blank" do
    lambda do
      Contact.create!(:name => "Chuck Norris", :company_name => "")
    end.should_not change(Company, :count)
  end
end
