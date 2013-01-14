require File.dirname(__FILE__) + '/../../spec_helper'

describe Clientela::Base do
  describe "Class Methods" do
    describe "url" do
      it "should return full url based in domain" do
        Clientela::Base.url("example").should == "example.clientela.com.br"
      end
    end
    
    describe "polymorphic_email_dropbox" do
      it "should create drop mail tag" do
        Account.current = FactoryGirl.create(:example)
        contact = mock_model(Contact, :id => 1234567)

        Clientela::Base.polymorphic_email_dropbox(contact).should == "dropbox+#{Account.current.domain}+contact+1234567@clientela.com.br"
      end
    end
  end
end