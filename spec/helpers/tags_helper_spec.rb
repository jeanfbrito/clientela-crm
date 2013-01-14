require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TagsHelper do
  describe "most_used_tags" do
    it "should return default tags if no tags used" do
      Contact.should_receive(:tag_counts_on).and_return([])
      helper.most_used_tags.should == ["Cliente", "Fornecedor", "Prospect", "Lead", "Aluno", "Tutor", "Vip", "Rio de Janeiro"]
    end

    it "should prefer already used tags" do
      helper.most_used_tags.should == ["Cliente", "Fornecedor", "Prospect", "Lead", "Aluno", "Tutor", "Vip", "Rio de Janeiro"]
    end
  end
end
