# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  let!(:quentin) { FactoryGirl.create(:quentin) }
  let!(:fake) { FactoryGirl.create(:fake) }
  describe "users_not_myself" do
    context "quentin" do
      before do
        helper.should_receive(:current_user).and_return(quentin)
      end

      it "should return other user" do
        helper.users_not_myself.should == [fake]
      end
    end
  end

  describe "tip_box" do
    it "should delegate to Clientela::Helpers::TipBox" do
      Clientela::Helpers::TipBox.should_receive(:new).with(:header => "header", :body => "content").and_return("tip_box")
      helper.tip_box(:header => "header") { "content" }.should == "tip_box"
    end
  end

  describe "menu_item_with_plus" do
    before(:each) do
      helper.should_receive(:t).with(".add_contacts").and_return("Add a contact")
      helper.should_receive(:t).with(".add_html").and_return("Add")
      helper.should_receive(:t).with(".contacts").and_return("Contacts")
    end

    it "should have the add new button" do
      helper.menu_item_with_plus(:contacts, :class => "contacts").should == %{<li class="contacts"><a href="http://test.host/contacts/new" class="button add-new" title="Add a contact">Add</a> <a href="http://test.host/contacts">Contacts</a></li>}
    end

    it "should mark as current" do
      helper.should_receive(:current_page?).and_return(true)
      helper.menu_item_with_plus(:contacts, :class => "contacts").should =~ /class="current contacts"/
    end
  end

  describe "menu_item" do
    before(:each) do
      helper.should_receive(:send).with("dashboard_url").and_return("url")
      helper.should_receive(:t).with(".dashboard").and_return("Dashboard")
    end

    it "should mark as current" do
      helper.should_receive(:current_page?).and_return(true)
      helper.menu_item(:dashboard).should == %{<li class="current"><a href="url">Dashboard</a></li>}
    end

    it "should also concat other css classes" do
      helper.should_receive(:current_page?).and_return(true)
      helper.menu_item(:dashboard, :class => "other").should == %{<li class="current other"><a href="url">Dashboard</a></li>}
    end

    it "should not mark as current" do
      helper.should_receive(:current_page?).and_return(false)
      helper.menu_item(:dashboard).should == %{<li class=""><a href="url">Dashboard</a></li>}
    end
  end

  describe "destroy links" do
    before(:each) do
      @record = mock_model(Contact, :id => "666")
    end

    describe "link_to_destroy" do
      it "should generate destroy link of the object" do
        helper.should_receive(:t).with(".destroy").and_return("Apagar")
        helper.should_receive(:t).with("common.delete_confirmation").and_return("Tem certeza?")
        helper.link_to_destroy(@record).should == %{<a href="/contacts/666" data-confirm="Tem certeza?" data-method="delete" rel="nofollow">Apagar</a>}
      end
    end

    describe "link_to_icon_destroy" do
      it "should generate icon link to destroy" do
        helper.should_receive(:image_tag).with("iconika-grey-icons/16x16/recycle_bin.png").and_return("image")
        helper.link_to_icon_destroy(@record, {:remote => true}).should == %{<a href="/contacts/666" data-confirm="Você realmente deseja apagar?" data-method="delete" data-remote="true" rel="nofollow">image</a>}
      end
    end

    describe "link_to_icon_destroy_remote" do
      it "should call link_to_icon_destroy" do
        helper.should_receive(:link_to_icon_destroy).with(@record, {:remote => true, :title => t("common.remove")}).and_return("link_to_icon_destroy")
        helper.link_to_icon_destroy_remote(@record).should == "link_to_icon_destroy"
      end
    end
  end

  describe "listing" do
    it "should eval body and delegate to Clientela::Helpers::Listing" do
      helper.listing(:records => ["work", "home"]) { |r| r }.to_s.should == %{<table class="listing"><tbody><tr>work</tr><tr>home</tr></tbody></table>}
    end
  end

  describe "avatar" do
    it "should return avatar html" do
      helper.should_receive(:image_tag).with("avatar_small.png").and_return 'image'
      helper.avatar.should == %{<td class="avatar">image</td>}
    end
  end

  describe "content" do
    it "should return contend tag" do
      helper.content { 'content' }.should == %{<td class="content">content</td>}
    end
  end

  describe "buttons" do
    it "should return button tag" do
      helper.buttons { 'content' }.should == %{<td class="buttons">content</td>}
    end
  end

  describe "render_tag_list" do
    it "should render tag list" do
      helper.should_receive(:render).with({:locals=>{:tags=>"tags"}, :partial=>"tags/sidebar_list"}).and_return 'render tag list'
      helper.render_tag_list("tags").should == 'render tag list'
    end
  end

  describe "users_for_task_assign" do
    it "should return me first" do
      helper.stub!(:t).and_return("Eu")
      helper.stub!(:current_user).and_return(quentin)
      helper.users_for_assign.should == [["Fake User", fake.id],["Quentin Tarantino (Eu)", quentin.id]]
    end
  end

  describe "aprovo" do
    it "should return a button to track on mixpanel with aprovo as id" do
      helper.aprovo("example","3").should == %{<a href="#aprovo" id="aprovo" onclick="MixPanel.track_new_interface('aprovo', 'example', '3'); return false;" title="aprovo"></a>}
    end
  end

  describe "desaprovo" do
    it "should return a button to track on mixpanel with desaprovo as id" do
      helper.desaprovo("example","3").should == %{<a href="#desaprovo" id="desaprovo" onclick="MixPanel.track_new_interface('desaprovo', 'example', '3'); return false;" title="desaprovo"></a>}
    end
  end
end
