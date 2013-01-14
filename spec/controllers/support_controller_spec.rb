require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SupportController do
  it "should render api doc" do
    sign_in_quentin
    get :api
    response.should render_template("api")
  end
end
