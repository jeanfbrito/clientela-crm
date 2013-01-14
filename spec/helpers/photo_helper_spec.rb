require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PhotoHelper do

  describe "small_thumb_tag" do
    it "should render small thumb tag" do
      helper.should_receive(:image_tag).with('image').and_return('image-mock')
      helper.small_thumb_tag('image').should == %{<div class="avatar">image-mock</div>}
    end
  end

  describe "photo tag" do
    before(:each) do
      @photo = mock('photo')
      @photo.should_receive(:url).with(anything).and_return('/photo-url')
    end

    describe "if user have email" do
      before(:each) do
        @record = mock('record', :photo => @photo, :class => Contact, :emails => [mock(:address => "quentin@example.com")], :name => "Quentin")
      end

      describe "small photo tag" do
        it "returns small photo image tag with gravatar" do
          helper.small_photo_tag(@record).should == %{<div class="avatar"><img alt="Quentin" height="50" src="https://secure.gravatar.com/avatar/9693e98bbda866fa0a85ac2669613a6b?s=50&d=http://test.host/photo-url" width="50" /></div>}
        end
      end

      describe "thumb photo tag" do
        it "returns thumb photo image tag with gravatar" do
          helper.thumb_photo_tag(@record).should == %{<div class="avatar"><img alt="Quentin" height="32" src="https://secure.gravatar.com/avatar/9693e98bbda866fa0a85ac2669613a6b?s=32&d=http://test.host/photo-url" width="32" /></div>}
        end
      end
    end

    describe "if user don't have email" do
      it "photo_tag returns image tag without gravatar" do
        record = mock('record', :photo => @photo, :class => Contact, :emails => [], :name => "Quentin")

        helper.small_photo_tag(record).should == %{<div class="avatar"><img alt="Quentin" height="50" src="/photo-url" width="50" /></div>}
      end
    end
  end
end