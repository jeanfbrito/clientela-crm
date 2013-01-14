require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BoxesHelper do  
  before(:each) do
    helper.stub(:t).and_return("translated")
  end

  describe "content_box" do
    it "should render content box" do
      helper.content_box { "content" }.should =~ /content/
    end
  end

  describe "sidebar_box" do
    it "should set sidebar content_for" do
      helper.sidebar_box { "content" }
      helper.instance_variable_get(:@_content_for)[:sidebar].should == "content"
    end
  end

  describe "sidebar_module_box" do
    it "should create sidebar module box" do
      helper.sidebar_module_box(:header => :sidebar_module_header) { "content" }.should == %{<div class="sidebar-module"><h2>translated</h2><div class="inner">content</div></div>}
    end

    it "should not translate if i18n is set to false" do
      helper.should_not_receive(:t)
      helper.sidebar_module_box(:header => "Text Header", :i18n => false) { "content" }.should == %{<div class="sidebar-module"><h2>Text Header</h2><div class="inner">content</div></div>}
    end
  end

  describe "inner_header" do
    it "should create default tag" do
      helper.inner_header.should == %{<div class="inner_header"><h1>translated</h1></div>}
    end

    it "should create tag with block" do
      helper.inner_header { "content" }
      helper.instance_variable_get(:@_content_for)[:inner_header].should == %{<div class="inner_header">content</div>}
    end
  end
end
