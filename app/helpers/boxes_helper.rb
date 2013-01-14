module BoxesHelper
  def sidebar_box(show_support_request = true, &block)
    content_for(:sidebar, capture(&block).html_safe)
  end

  def content_box(options = {}, &block)
    body = capture(&block)
    html = []
    html << inner_header
    html << content_tag(:div, body, :id => :main_content)
    html.join.html_safe
  end

  def inner_header(options = {}, &block)
    if !content_for?(:inner_header)
      content = if block_given?
        capture(&block)
      else
        content_tag(:h1, t(".header"))
      end
      content_for(:inner_header, content_tag(:div, content, :class => :inner_header))
    end
    content_for(:inner_header) unless block_given?
  end

  def sidebar_module_box(options = {}, &block)
    translate = (options[:i18n] != false)
    header_label = options[:header]
    header = translate ? t(".#{header_label}", :default => "common.#{header_label}".to_sym) : header_label
    content_tag :div, :class => :"sidebar-module" do
      content_tag(:h2, header) << content_tag(:div, :class => :inner) do
        capture(&block)
      end
    end
  end
end
