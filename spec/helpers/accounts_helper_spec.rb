# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AccountsHelper do
  describe "error_for_field" do
    before(:each) do
      @account = Account.new
      @form = mock('form-mock', :object => @account)
    end

    it "should show nothing when there is no error" do
      error_for_field(@form, :name).should be_nil
    end

    it "should return error tag if field with error" do
      @account.valid?
      helper.error_for_field(@form, :name).should == %{<div class="error">não pode ficar em branco</div>}
    end
  end
end