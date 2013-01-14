# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../../spec_helper'

describe Clientela::FormBuilder, :type => :form_builder do
  describe "Instance Methods" do
    def object
      @object ||= Contact.new
    end

    def object_with_error
      Account.current = Account.first
      @object_with_error = Contact.new
      @object_with_error.valid?
      @object_with_error
    end

    def resulted_form_for(o = nil, &block)
      @resulted_form_for ||= form_for(o || object, :builder => Clientela::FormBuilder, &block).to_s
    end

    describe "text_field" do
      it "should accept text fields" do
        resulted_form_for { |f| f.text_field_with_label(:name) }
        resulted_form_for.should include(%{<input id="contact_name" name="contact[name]" size="30" type="text" />})
      end

      it "should concatenate with label" do
        resulted_form_for { |f| f.text_field_with_label(:name) }
        resulted_form_for.should include(%{<label for="contact_name">Nome</label>})
      end

      it "should concatenate with error if exists" do
        resulted_form_for(object_with_error) { |f| f.text_field_with_label(:name) }
        resulted_form_for.should include(%{<div class="error">não pode ficar em branco</div>})
      end

      it "should wrap with a div" do
        resulted_form_for { |f| f.text_field_with_label(:name) }
        resulted_form_for.should =~ /<div class="attribute">.*<\/div>/
      end

      it "should accept wrapper_class attribute" do
        resulted_form_for { |f| f.text_field_with_label(:name, :wrapper_class => "highlight") }
        resulted_form_for.should =~ /<div class="highlight attribute">.*<\/div>/
      end
    end

    describe "text_area" do
      it "should accept textarea" do
        resulted_form_for { |f| f.text_area_with_label(:name) }
        resulted_form_for.should include(%{<textarea id="contact_name" name="contact[name]"></textarea>})
      end

      it "should concatenate with label" do
        resulted_form_for { |f| f.text_area_with_label(:name) }
        resulted_form_for.should include(%{<label for="contact_name">Nome</label>})
      end

      it "should wrap with a div" do
        resulted_form_for { |f| f.text_area_with_label(:name) }
        resulted_form_for.should =~ /<div class="attribute">.*<\/div>/
      end
    end

    describe "select_field" do
      it "should accept select_field" do
        resulted_form_for { |f| f.select_field_with_label(:name, { "Any Name" => "1" }) }
        resulted_form_for.should include(%{<select id="contact_name" name="contact[name]"><option value="1">Any Name</option></select>})
      end

      it "should concatenate with label" do
        resulted_form_for { |f| f.select_field_with_label(:name) }
        resulted_form_for.should include(%{<label for="contact_name">Nome</label>})
      end

      it "should wrap with a div" do
        resulted_form_for { |f| f.select_field_with_label(:name) }
        resulted_form_for.should =~ /<div class="attribute">.*<\/div>/
      end
    end

    describe "file field" do
      it "should accept file fields" do
        resulted_form_for { |f| f.file_field_with_label(:photo) }
        resulted_form_for.should include(%{<input id="contact_photo" name="contact[photo]" type="file" />})
      end
    end

    describe "password_field" do
      it "should accept password_field" do
        resulted_form_for { |f| f.password_field_with_label(:name) }
        resulted_form_for.should include(%{<input autocomplete="off" id="contact_name" name="contact[name]" size="30" type="password" />})
      end

      it "should concatenate with label" do
        resulted_form_for { |f| f.password_field_with_label(:name) }
        resulted_form_for.should include(%{<label for="contact_name">Nome</label>})
      end

      it "should wrap with a div" do
        resulted_form_for { |f| f.password_field_with_label(:name) }
        resulted_form_for.should =~ /<div class="attribute">.*<\/div>/
      end

      it "should accept hint" do
        resulted_form_for { |f| f.password_field_with_label(:name, :hint => "Any hint to be displayed") }
        resulted_form_for.should include(%{<div class="hint">Any hint to be displayed</div>})
      end
    end

    describe "autocomplete_field" do
      it "should accept autocomplete fields" do
        resulted_form_for { |f| f.autocomplete_field_with_label(:name, :url => "/test") }
        resulted_form_for.should have_selector(%{input[data-autocomplete="/test"]})
        resulted_form_for.should have_selector(%{img[class="spinner"][id=contact_name_spinner]})
      end

      it "should concatenate with label" do
        resulted_form_for { |f| f.autocomplete_field_with_label(:name, :url => "/test") }
        resulted_form_for.should include(%{<label for="contact_name">Nome</label>})
      end

      it "should wrap with a div" do
        resulted_form_for { |f| f.autocomplete_field_with_label(:name) }
        resulted_form_for.should =~ /<div class="label"><label.*<\/div>/
      end
    end

    describe "spinner_submit" do
      it "should render submit with spinner" do
        resulted_form_for { |f| f.spinner_submit }
        resulted_form_for.should have_selector(%{img[class="spinner"]})
        resulted_form_for.should have_selector(%{input[type="submit"]})
        resulted_form_for.should have_selector(%{input[value="Adicionar"]})
      end

      it "should wrap with a div" do
        resulted_form_for { |f| f.spinner_submit }
        resulted_form_for.should =~ /<div>.*<\/div>/
      end
    end
  end
end
