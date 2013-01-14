require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Contact do
  before(:each) do
    account = mock_model(Account, :id => '42')
    Account.stub(:current).and_return(account)
  end

  should_validate_presence_of :name
  # should_have_default_scope :order => 'name asc'
  should_have_many :tasks, :dependent => :destroy
  should_have_many :relationships, :dependent => :destroy
  should_belong_to :company
  should_belong_to :imported_by, :class_name => 'ContactImport'

  let!(:tabajara) { FactoryGirl.create(:company_tabajara) }

  describe "create or find company by name" do
    describe "with existing company" do
      it "should set company" do
        lambda do
          contact = Contact.create!(:name => "My name", :company_name => "Tabajara")
          contact.company.should == tabajara
        end.should_not change(Company, :count)
      end
    end

    describe "with new company" do
      it "should create a new company" do
        lambda do
          contact = Contact.create!(:name => "My name", :company_name => "Lojas Americanas")
          contact.company.should be_kind_of(Company)
        end.should change(Company, :count).by(1)
      end
    end
  end

  describe "company_name return company.name" do
    it "should return company.name" do
      FactoryGirl.create(:contact_joseph).company_name.should == "Tabajara"
    end

    it "should not break if contact don't have company" do
      FactoryGirl.create(:contact_quentin).company_name.should be_nil
    end
  end

  describe "autocomplete title" do
    it "should query to autocomplete" do
      Contact.autocomplete_title("sam").to_sql.should == %{SELECT  distinct title FROM "entities" WHERE "entities"."type" = 'Contact' AND (LOWER(title) LIKE '%sam%') ORDER BY title ASC LIMIT 10}
    end
  end

  describe "initials" do
    let!(:quentin) { FactoryGirl.create(:contact_quentin) }
    let!(:joseph) { FactoryGirl.create(:contact_joseph) }
    it "should return only initials that have contact" do
      Contact.initials.should == %w{J Q}
    end
  end

  describe ".delete_photo=" do
    it "should set photo to nil" do
      contact = FactoryGirl.create(:contact_quentin)
      contact.should_receive(:photo=).with(nil)
      contact.delete_photo = 1
    end

    it "should not set photo to nil" do
      contact = FactoryGirl.create(:contact_quentin)
      contact.should_not_receive(:photo=)
      contact.delete_photo = nil
    end
  end

  describe ".deals" do
    it "should delegate to relationship" do
      FactoryGirl.create(:contact_quentin).deals.should == []
    end
  end

  describe ".facts" do
    it "should delegate to relationship" do
      FactoryGirl.create(:contact_quentin).facts.should == []
    end
  end
end
