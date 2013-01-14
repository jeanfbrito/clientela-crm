require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NotesController do
  it_should_respond_to :html, :xml, :json
  it_should_have_actions :edit, :destroy, :create, :update
  it_should_be_inherited_resource

  before(:each) do
    sign_in_quentin
  end

  let!(:contact) { FactoryGirl.create(:contact_quentin) }

  describe "POST create" do
    def mock_note(stubs={})
      @mock_note ||= mock_model(Note, stubs).as_null_object
    end

    it "redirects to the created contact" do
      Note.stub(:new) { mock_note(:notable => contact, :save => true) }
      post :create, :note => {}
      response.should redirect_to(mock_note.notable)
    end

    it "should assings note's author" do
      controller.should_receive(:current_user).at_least(1).times.and_return(User.last)
      post :create, :note => {:content => "conteudo", 'notable_id' => contact.id, 'notable_type' => 'Contact'}
      assigns(:note).author.should eq(User.last)
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested note" do
      note = mock()
      note.should_receive(:destroy).and_return(true)
      note.should_receive(:notable).and_return(contact)
      Note.should_receive(:find).with('2').and_return(note)
      delete :destroy, :id => '2'
      response.should redirect_to(contact)
    end
  end

  describe "PUT update" do
    it "updates the requested contact" do
      note = mock()
      note.should_receive(:update_attributes).with('params' => 'value').and_return(true)
      note.should_receive(:notable).and_return(contact)
      Note.should_receive(:find).with('42').and_return(note)
      put :update, :id => '42', :note => {'params' => 'value'}
      response.should redirect_to(contact_url(contact))
    end
  end
end
