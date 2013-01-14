# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Note do
  before(:each) do
    Account.current = FactoryGirl.create(:example)
  end

  let!(:user) { FactoryGirl.create(:quentin) }
  let!(:contact) { FactoryGirl.create(:contact_joseph) }

  should_validate_presence_of :content
  should_validate_presence_of :author
  should_belong_to :notable, :polymorphic => true
  should_belong_to :author, :class_name => "User"
  should_belong_to :related_email, :class_name => "ReceivedEmail"
#  should_have_default_scope :order => 'created_at DESC'

  it "should have proposal scope" do
    Note.proposal.to_sql.should == %{SELECT "notes".* FROM "notes" WHERE "notes"."proposal" = 't' ORDER BY created_at DESC}
  end

  it "should have with_image scope" do
    Note.with_image.to_sql.should == %{SELECT "notes".* FROM "notes" WHERE (attachment_content_type like 'image%') ORDER BY created_at DESC}
  end

  context "paperclip validations" do
    before {mock_paperclip_for(Note)}
    it { should have_attached_file(:attachment) }
  end

  describe "unquoted_content" do
    let(:note) { FactoryGirl.create(:note_quentin) }
    context "with standard content" do
      let(:content) { File.open(Rails.root.join('spec','fixtures','notes','standard_content')).read }
      it "should return only the unquoted part" do
        note.content = content
        note.unquoted_content.should == %{O nosso contrato padrão, que enviei pra vc no e-mail anterior...\n\nUm abraço!\n\n--\nSylvestre Mergulhão\ncontato@startupdev.com.br\n}
      end
    end
    context "with email quoted content like gmail" do
      let(:content) { File.open(Rails.root.join('spec','fixtures','notes','email_quoted_content')).read }
      it "should return only the unquoted part" do
        note.content = content
        note.unquoted_content.should == %{O nosso contrato padrão, que enviei pra vc no e-mail anterior...\n\nUm abraço!\n\n--\nSylvestre Mergulhão\ncontato@startupdev.com.br\n\n}
      end
    end
  end

  describe "author_name" do
    it "should save author_name on db" do
      Note.create!(:author => user, :content => "x", :notable => contact).author_name.should == "Quentin Tarantino"
    end
  end

  describe "notifications" do
    def create_note!
      Note.create!(:author => user, :content => "x", :notable => contact, :notifications => { user.id.to_s => "1" })
    end

    it "should create subscription" do
      expect {
        create_note!
      }.to change(Subscription, :count).by(1)
    end
    describe "subscriptions parameters" do
      before do
        @note = create_note!
      end

      subject { Subscription.last }

      it "should set correct subject" do
        subject.subject.should == contact
      end
      it "should set correct subscriber" do
        subject.subscriber.should == user
      end
    end
  end
end
