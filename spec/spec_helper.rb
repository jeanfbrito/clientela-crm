# This file is copied to spec/ when you run 'rails generate rspec:install'
if ENV['coverage'] == 'on'
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter "/admin/users_controller"
    add_filter "/lib/debug_helper"
  end
end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'remarkable/active_record'
require "paperclip/matchers"
require "cancan/matchers"
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

FakeWeb.allow_net_connect = false
Faker::Config.locale = "en"

module Devise::TestHelpers
  def sign_in_quentin
    u = FactoryGirl.create(:quentin)
    sign_in u
  end
end

module CustomTestHelpers
  def contacts(args)
    entities(*args)
  end

  def uploaded_file(filename, content_type = "text/csv")
    t = Tempfile.new(filename.split("/").last)
    t.binmode
    path = File.join(Rails.root, "spec", "fixtures", filename)
    FileUtils.copy_file(path, t.path)
    (class << t; self; end).class_eval do
      alias local_path path
      define_method(:original_filename) {filename}
      define_method(:content_type) {content_type}
    end
    return t
  end
  def mock_paperclip_for klass
    klass.any_instance.stub(:save_attached_files).and_return(true)
    klass.any_instance.stub(:delete_attached_files).and_return(true)
    Paperclip::Attachment.any_instance.stub(:post_process).and_return(true)
  end
end

module InheritedResourcesTestHelpers
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def it_should_be_inherited_resource
      it "should be a inherited_resource" do
        controller.class.ancestors[1].should == InheritedResources::Base
      end
    end

    def it_should_have_actions(*params)
      it "should have actions" do
        params.each do |controller_action|
          controller.action_methods.map(&:to_sym).should include(controller_action)
        end
      end

      it "should not have other actions" do
        controller.action_methods.map(&:to_sym).each do |controller_action|
          params.should include(controller_action)
        end
      end
    end

    def it_should_respond_to(*params)
      it "should respond to" do
        params.each do |respond_to_method|
          controller.mimes_for_respond_to.should include(respond_to_method)
        end
      end
    end
  end
end

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  # config.global_fixtures = :all

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  config.include Devise::TestHelpers, :type => :controller
  config.include Paperclip::Shoulda::Matchers
  config.include ResqueUnit::Assertions
  config.include RSpec::Rails::ViewExampleGroup, :type => :form_builder
  config.include ActionDispatch::TestProcess
  config.include CustomTestHelpers
  config.include(InheritedResourcesTestHelpers, :type => :controller)

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before :each do
    Time.zone = ActiveSupport::TimeZone['UTC']
  end

  config.before :all do
    ActionMailer::Base.default_url_options = { :host => "example.clientela.com.br" }
  end
end

module RSpec::Rails; module ControllerExampleGroup; def flunk(message); assert_block(message){false}; end; end; end
