require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FormsHelper do  
  describe "options_with_translation" do
    it "should return options with translation" do
      helper.should_receive(:t).with(".item").and_return("Translated Item")
      helper.options_with_translation([:item]).should == [["Translated Item", :item]]
    end
  end

  describe "remove_child_link" do
    it "should create remove child link" do
      form_mock = mock('form')
      form_mock.should_receive(:hidden_field).with(:_destroy).and_return('hidden-field ')
      helper.remove_child_link("delete", form_mock).should == %{hidden-field <a href="javascript:void(0)" class="remove_child">delete</a>}
    end
  end

  describe "add_child_link" do
    it "should create add child link" do 
      helper.add_child_link("new", :tasks).should == %{<a href="javascript:void(0)" class="add_child" data-association="tasks">new</a>}
    end
  end

  describe "new_child_fields_template" do
    it "should create template to new child" do
      helper.should_receive(:render).with(hash_including(:partial => 'entities/phone')).and_return('render-partial')
      form_for(Contact.new) do |f|
        helper.new_child_fields_template(f, :phones).should == %{<div class="template" id="phones_fields_template" style="display: none">render-partial</div>}
      end
    end
  end

  describe "nested_attribute" do
    def resulted_form_for(object = Contact.new, &block)
      @resulted_form_for ||= form_for(object, :builder => Clientela::FormBuilder, &block).to_s
    end

    before(:each) do
      helper.stub!(:t).with("entities.form.new_website").and_return("New Website")
      helper.stub!(:new_child_fields_template).and_return("")
    end

    it "should wrap with a div" do
      resulted_form_for { |f| helper.nested_attribute(f, :websites).should =~ /<div class="multiple attribute">.*<\/div>/ }
    end

    it "should contain a label" do
      resulted_form_for { |f| helper.nested_attribute(f, :websites).should include(%{<label for="contact_websites">Website</label>}) }
      resulted_form_for
    end

    it "should contain a div with class 'field-container'" do
      resulted_form_for { |f| helper.nested_attribute(f, :websites).should =~ /<div class="field fields-container" id="websites-fields">.*<\/div>/ }
    end

    it "should contain form fields" do
      contact = FactoryGirl.create(:contact_quentin)
      contact.websites << Website.new(:url => "http://abc", :kind => "work")

      resulted_form_for(contact) do |f|
        helper.should_receive(:render).twice.with(hash_including(:partial => "entities/website")).and_return("render-mock")
        helper.nested_attribute(f, :websites).should have_selector(%{input[id="contact_websites_attributes_0_id"]})
        helper.nested_attribute(f, :websites).should =~ /render-mock/
      end
    end

    it "should contain add_child_link" do
      helper.should_receive(:add_child_link).with("New Website", :websites).and_return("add-child-link-mock")
      resulted_form_for { |f| helper.nested_attribute(f, :websites).should =~ /<p>add-child-link-mock<\/p>/ }
    end

    it "should contain new_child_fields_template" do
      resulted_form_for do |f|
        helper.should_receive(:new_child_fields_template).with(f, :websites).and_return("new-child-fields-template-mock")
        helper.nested_attribute(f, :websites).should =~ /new-child-fields-template-mock/
      end
    end
  end

  describe "spinner_submit_with_cancel" do
    it "should create submit button concatenated with or cancel" do
      form_for(Contact.new) do |f|
        helper.should_receive(:spinner_submit).with(f).and_return('spinner-submit-mock')
        helper.spinner_submit_with_cancel(f).should == %{<div class="actions">spinner-submit-mock ou <a href="javascript:history.back()">Cancelar</a></div>}
      end      
    end
  end

  describe "spinner_submit" do
    it "should create submit button and spinner" do
      helper.should_receive(:image_tag).with("spinner.gif", :class => "spinner").and_return("image-tag")
      form_for(Contact.new) do |f|
        helper.spinner_submit(f).should ==%{image-tag<input class="button" id="contact_submit" name="commit" type="submit" value="Adicionar" />}
      end
    end
  end
end