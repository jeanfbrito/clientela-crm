# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ContactImport do

  before(:each) do
    Account.current = FactoryGirl.create(:example)
  end

  # should_validate_inclusion_of :kind, :in => %w(highrise regular), :allow_nil => false
  should_have_many :imported_contacts, :class_name => 'Contact', :foreign_key => :imported_by_id
  context "paperclip validations" do
    before do
      mock_paperclip_for(ContactImport)
    end

    it { should have_attached_file(:file) }
    # it { should validate_attachment_size(:file).less_than(10.megabytes) }
    # it { should validate_attachment_presence(:file) }
    it { should validate_attachment_content_type(:file).
         rejecting('image/png', 'image/gif', 'image/jpg', 'image/x-png', 'image/pjpeg', 'text/xml').
         allowing('text/plain', 'text/csv', 'application/octet-stream') }
  end


  describe ".revert" do
    it "should delete contacts created by that import" do
      @import = ContactImport.create!({:file => uploaded_file("contact_imports/highrise-1-contacts.csv-file"), :kind => "highrise"})
      @import.execute_highrise!

      lambda do
        @import.revert!
      end.should change(Contact, :count).by(-1)
    end
  end

  describe ".execute highrise" do
    describe "success" do
      describe "Contact" do
        before(:each) do
          @import = ContactImport.create!({:file => uploaded_file("contact_imports/highrise-1-contacts.csv-file"), :kind => "highrise"})
          lambda do
            @import.execute_highrise!
          end.should change(Contact, :count).by(1)
        end

        it "should import a full contact correctly" do
          contact = Contact.find_by_name("Quentin \"Quibe\" Tarantino")
          contact.emails.first.address.should == "quentin@example.com"
          contact.phones.first.number.should == "(12) 1111-1111"
          contact.title.should == "Diretor Administrativo"
          contact.company_name.should == "Quentin Security"
        end
      end

      describe "Company" do
        before(:each) do
          @import = ContactImport.create!({:file => uploaded_file("contact_imports/highrise-1-contacts.csv-file"), :kind => "highrise"})
          lambda do
            @import.execute_highrise!
          end.should change(Company, :count).by(2)

        end

        it "should import a company correctly" do
          company = Company.find_by_name("Agence")
          company.name.should == "Agence"
          company.tag_list.sort.should == ["desenvolvimento", "rio de janeiro/rj", "são paulo/sp", "web"]
          company.addresses.first.street.should == "Av. Rio Branco, 123"
          company.phones.first.number.should == "(11) 8888-8888"
          company.emails.first.address.should == "contato@example.com"
          company.websites.first.url.should == "http://www.example.com"
        end
      end
    end
  end

  describe ".execute simple import" do
    describe "with failures" do
      before(:each) do
        @import = ContactImport.create!(:file => uploaded_file("contact_imports/simple-5-contacts-with-error.csv-file"), :kind => "regular")
        lambda do
          @import.execute!
        end.should change(Contact, :count).by(2)
      end

      it "should save error log" do
        @import.log.should == %{Linha 3: A validação falhou: Name não pode ficar em branco
Linha 4: A validação falhou: Name não pode ficar em branco
Linha 5: A validação falhou: Name não pode ficar em branco
Linha 6: A validação falhou: Name não pode ficar em branco}
      end
    end

    describe "only success" do
      before(:each) do
        @time_when_started = DateTime.now
        @contact = FactoryGirl.create(:contact_joseph, emails: [FactoryGirl.create(:email)], phones: [FactoryGirl.create(:phone)], tag_list: ["Partner"])
        @import = ContactImport.create!(:file => uploaded_file("contact_imports/simple-5-contacts.csv-file"), :kind => "regular")
        lambda do
          @import.execute!
        end.should change(Contact, :count).by(5)
      end

      it "should import a full contact correctly" do
        contact = Contact.find_by_name!("Johnny Cash")
        contact.emails.first.address.should == "john@king.com"
        contact.phones.first.number.should == "768-432-1234"
        contact.title.should == "Player"
        contact.company_name.should == "Country Records Inc"
        contact.websites.first.url.should == "http://www.johnnycash.com"
      end

      it "should import a missing data contact correctly" do
        contact = Contact.find_by_name!("Cristiane Example")
        contact.emails.should be_empty
        contact.phones.should be_empty
        contact.title.should be_empty
        contact.company_name.should be_nil
        contact.websites.should be_empty
      end

      it "should import another missing data contact correctly" do
        contact = Contact.find_by_name!("Daniela Example")
        contact.emails.first.address.should == "daniela@example.com"
        contact.phones.should be_empty
        contact.title.should be_nil
        contact.company_name.should be_nil
        contact.websites.should be_empty
        contact.tag_list.should == ["EAD"]
      end

      it "should update missing data contact correctly" do
        new_import = ContactImport.create!(:file => uploaded_file("contact_imports/simple-5-contacts-with-missing-fields.csv-file"), :kind => "regular")
        new_import.execute!
        new_import.log.should be_blank, "the log message is saying: #{new_import.log}"

        contact = Contact.find_by_name!("Daniela Example")
        contact.emails.first.address.should == "daniela@example.com"
        contact.phones.should be_empty
        contact.title.should be_nil
        contact.company_name.should be_nil

        contact.websites.should be_empty
        contact.tag_list.sort.should == ["CAD", "EAD"]
      end

      it "should merge contact based on email" do
        @contact.reload.name.should == "Talita Example"
        @contact.reload.emails.first.address.should == "amorin@example.com"
        @contact.reload.phones.map(&:number).sort.should == ["386-883-4410", "987-123-1234"]
        @contact.reload.title.should == "Letrista"
        @contact.reload.company_name.should == "Casa Rosa"
        @contact.reload.websites.first.url.should == "http://talita.com"
        @contact.reload.tag_list.sort.should == ["Letra", "Partner"]
      end

      it "should import tags if present" do
        contact = Contact.find_by_name!("Joviano Example")
        contact.tag_list.should include("Artista")
      end

      it "should link imported contact with contact import object" do
        contact = Contact.find_by_name!("Patricia Mendes Example")
        contact.imported_by.should == @import
      end

      it "should mark import as done" do
        @import.imported_at.should >= @time_when_started
      end

      it "should have empty log" do
        @import.log.should be_blank
      end
    end
  end

  describe "after create schedule" do
    it "should schedule import in resque" do
      import = ContactImport.new(:file => uploaded_file("contact_imports/simple-5-contacts.csv-file"), :kind => "highrise")
      import.stub!(:id).and_return(666)
      import.save!

      assert_queued(ContactImport, [Account.current.id, 666])
    end

    context "regular import" do
      describe "perform resque method" do
        it "should execute import on specified account" do
          Account.should_receive(:configure_by_id).with(6).and_return(mock_model(Account))

          contact_import = mock_model(ContactImport, :kind => "regular")
          contact_import.should_receive(:execute!)
          ContactImport.should_receive(:find).with(7).and_return(contact_import)

          ContactImport.perform(6, 7)
        end
      end
    end

    context "highrise import" do
      describe "perform resque method" do
        it "should execute import on specified account" do
          Account.should_receive(:configure_by_id).with(6).and_return(mock_model(Account))

          contact_import = mock_model(ContactImport, :kind => "highrise")
          contact_import.should_receive(:execute_highrise!)
          ContactImport.should_receive(:find).with(7).and_return(contact_import)

          ContactImport.perform(6, 7)
        end
      end
    end
  end
end
