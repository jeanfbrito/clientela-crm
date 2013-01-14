require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CompaniesController do
  it_should_respond_to :html, :xml, :json
  it_should_have_actions :edit, :show, :update
  it_should_be_inherited_resource

  before(:each) do
    sign_in_quentin
  end

  describe "PUT update" do
    before(:each) do
      @company = mock_model(Company)
      Company.should_receive(:find).with('42').and_return(@company)
      @company.should_receive(:update_attributes).with('params' => 'value').and_return(true)
    end

    it "updates the requested company" do
      put :update, :id => '42', :company => {'params' => 'value'}
      response.should redirect_to(company_url(@company))
    end

    it "should redirect to referer if it exists" do
      put :update, :id => '42', :company => {'params' => 'value'}, :referer => 'http://path/'
      response.should redirect_to('http://path/')
    end
  end
end
