require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActsAsTaggableOnExtensions do
  def tags(sym)
    ActsAsTaggableOn::Tag.named(sym).first
  end

  let!(:owner) { FactoryGirl.create(:tag_owner) }
  let!(:partner) { FactoryGirl.create(:tag_partner) }

  describe "to_param" do
    it "should return id-parmalink" do
      owner.to_param.should == "#{owner.id}-owner"
    end
  end

  describe "on association" do
    before(:each) do
      @record = FactoryGirl.create(:contact_quentin)
      @tag = FactoryGirl.create(:tag_owner_quentin, tag_id: owner.id, taggable_id: @record.id)
    end

    it "should create grouped_by_initial" do
      @record.tags.respond_to?(:grouped_by_initial)
    end

    it "should group tag by initial" do
      @record.tags.grouped_by_initial.should == [["O", [owner]]]
    end
  end

  describe "on class methods" do
    before(:each) do
      quentin =FactoryGirl.create(:contact_quentin)
      joseph = FactoryGirl.create(:contact_joseph, imported_by: nil)
      owner_tag = FactoryGirl.create(:tag_owner_quentin, tag_id: owner.id, taggable_id: quentin.id)
      partner_tag = FactoryGirl.create(:tag_partner_joseph, tag_id: partner.id, taggable_id: joseph.id)
    end

    it "should create grouped_by_initial" do
      Contact.respond_to?(:grouped_by_initial)
    end

    it "should group tag by initial" do
      Contact.tags_grouped_by_initial.should == [
        ["O", [owner]],
        ["P", [partner]]
      ]
    end
  end
end