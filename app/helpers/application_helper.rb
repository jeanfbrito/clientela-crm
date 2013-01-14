module ApplicationHelper
  def users_not_myself
    User.active.where(["id != ?", current_user.id])
  end

  def users_for_assign
    User.active.map { |user| [user_name_for_select(user), user.id] }
  end

  def user_name_for_select(user)
    if user == current_user
      "#{user.name} (#{t("common.me")})"
    else
      user.name
    end
  end

  def simple_menu_item(url, label, options = {})
    content_tag :li, :class => menu_item_current_css_class(url, options) do
      link_to(label, url)
    end
  end

  def menu_item_with_plus(item, options = {})
    label = t(".#{item}")
    collection_url = send("#{item}_url")
    new_object_url = send("new_#{item.to_s.singularize}_url")

    content_tag :li, :class => menu_item_current_css_class(collection_url, options) do
      r = [link_to(t(".add_html"), new_object_url, :title => t(".add_#{item}"), :class => "button add-new")]
      r << link_to(label, collection_url)
      r.join(" ").html_safe
    end
  end
  
  def menu_item(item, options = {})
    simple_menu_item(send("#{item}_url"), t(".#{item}"), options)
  end

  def tip_box(options = {}, &block)
    Clientela::Helpers::TipBox.new(:header => options[:header], :body => capture(&block))
  end

  def listing(options = {}, &block)
    body = options[:records].map { |r| content_tag(:tr, capture(r, &block)) }.join.html_safe
    Clientela::Helpers::Listing.new({:body => body})
  end

  def avatar
    content_tag :td, :class => :avatar do
      image_tag  "avatar_small.png"
    end
  end

  def content(&block)
    content_tag :td, :class => :content do
      capture(&block)
    end
  end

  def buttons(&block)
    content_tag :td, :class => :buttons do
      capture(&block)
    end
  end

  def link_to_icon_destroy(record, options = {})
    link_to(image_tag("iconika-grey-icons/16x16/recycle_bin.png"), record, {:method => :delete, :confirm => t("common.delete_confirmation")}.merge(options))
  end

  def link_to_icon_destroy_remote(record)
    link_to_icon_destroy(record, {:remote => true, :title => t("common.remove")})
  end

  def link_to_destroy(record)
    link_to(t(".destroy"), record, :method => :delete, :confirm => t("common.delete_confirmation"))
  end

  def render_tag_list(tags)
    render :partial => 'tags/sidebar_list', :locals => {:tags => tags}
  end

  def aprovo(account, user)
    mixpanel_a_button("aprovo", account, user)
  end

  def desaprovo(account, user)
    mixpanel_a_button("desaprovo", account, user)
  end

  private
  def mixpanel_a_button(kind, account, user)
    content_tag(:a, "", { :href     => "##{kind}", 
                          :id       => "#{kind}", 
                          :title    => "#{kind}",
                          :onclick  => %{MixPanel.track_new_interface('#{kind}', '#{account}', '#{user}'); return false;} 
                        })
  end

  def menu_item_current_css_class(url, options = {})
    klass = []
    klass << "current" if current_page?(url)
    klass << options[:class] if options[:class]
    klass.join(" ")
  end
end