# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Fact do
  should_validate_presence_of :name
  should_have_many :notes, :as => :notable, :dependent => :destroy
  should_have_many :tasks, :as => :taskable, :dependent => :destroy
  should_have_many :relationships, :dependent => :destroy, :as => :entity
  should_have_many :contacts, :through => :relationships
  should_have_scope :closed
  should_have_scope :opened

  should_have_many :subscriptions, :dependent => :destroy
  should_have_many :subscribers, :through => :subscriptions, :class_name => "User"

  describe "description split" do
    describe "special_fields" do
      it "should recognize two special fields" do
        FactoryGirl.create(:fact).special_fields.should == [["OS", "98394857"], ["Case", "Blasf"]]
      end
    end

    describe "only_description" do
      it "should return description without special fields" do
        FactoryGirl.create(:fact).only_description.should == "Aqui entra de fato a descrição desta ocorrêcnia com tudo o mais..."
      end
    end
  end
end
