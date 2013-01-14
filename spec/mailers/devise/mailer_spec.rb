require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Devise::Mailer do
  describe "invitation_instructions" do

    let!(:account) { FactoryGirl.create(:example, name: "Example 9999") }
    let!(:user) { FactoryGirl.create(:quentin, id: "9999") }

    before(:each) do
      Account.current = account
      @user = user
      @email = Devise::Mailer.invitation_instructions(@user)
    end

    it "should have from" do
      @email.from.should == ["mailer@clientela.com.br"]
    end

    it "should have to" do
      @email.to.should == ["#{user.email}"]
    end

    it "should have subject" do
      @email.subject.should == "[Clientela] Convite de acesso ao Clientela!"
    end

    it "should have right body" do
      @email.body.to_s.should == read_mail("invitation_instructions")
    end
  end
  
  private
  def read_mail(name)
    filename = Rails.root.join('spec','fixtures','devise','mailer',"#{name}.html")
    File.open(filename, 'w') {|f| f.write(@email.body) } unless File.exists?(filename)
    File.read(filename)
  end
end