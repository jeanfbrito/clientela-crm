require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Website do
  should_belong_to :entity
  should_validate_presence_of :url
  should_validate_inclusion_of :kind, :in => ["work", "personal", "blog", "other"], :allow_blank => false

  it "should return website kind" do
    Website.kinds.should == ["work", "personal", "blog", "other"]
  end
end
