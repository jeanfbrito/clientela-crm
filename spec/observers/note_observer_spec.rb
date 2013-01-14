# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NoteObserver do
  let!(:account) { FactoryGirl.create(:example) }
  let!(:fake) { FactoryGirl.create(:fake) }
  let!(:quentin) { FactoryGirl.create(:quentin) }

  before(:each) do
    Account.current = account
  end

  {
    :contacts => {
      :note => :note_quentin,
      :parent => { name: "Quentin", type: "contact" }
    },
    :companies => {
      :note => :note_helabs,
      :parent => { name: "helabs", type: "company" }
    },
    :deals => {
      :note => :note_quentin_deal_won,
      :parent => { name: "deal ganha do quentin", type: "deal" }
    },
    :facts => {
      :note => :note_service_order,
      :parent => { name: "My first service order", type: "fact" }
    },
  }.each do |key, value|
    describe "on #{key}" do
      before do
        @note = FactoryGirl.create(value[:note])
        @parent_object = @note.notable
        @parent = value[:parent].merge({id: @parent_object.id})
        @record = {:content => @note.content}
        @obs = NoteObserver.instance
      end

      it "should create new activity on create" do
        Activity.should_receive(:create).with(:activitable => @note, :action => "create", :parent => @parent, :record => @record)
        @parent_object.subscribers << [fake, quentin]

        lambda do
          @obs.after_create(@note)
        end.should change(ActionMailer::Base.deliveries, :size).by(2)
        ActionMailer::Base.deliveries.last.body.should =~ /Olá Quentin Tarantino/
      end

      it "should create new activity on destroy" do
        Activity.should_receive(:create).with(:activitable => @note, :action => "destroy", :parent => @parent, :record => @record )
        @obs.after_destroy(@note)
      end
    end
  end
end
