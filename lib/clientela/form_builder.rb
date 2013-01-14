module Clientela
  class FormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::AssetTagHelper

    def text_field_with_label(attribute, options={})
      wrapper_class = options.delete(:wrapper_class)
      result = n_label(attribute) + n_text_field(attribute, options) + error_field(attribute)
      n_attribute_wrapper(result, wrapper_class)
    end
    
    def text_area_with_label(attribute, options={})
      wrapper_class = options.delete(:wrapper_class)
      result = n_label(attribute) + n_text_area(attribute, options) + error_field(attribute)
      n_attribute_wrapper(result, wrapper_class)
    end

    def select_field_with_label(attribute, options={})
      wrapper_class = options.delete(:wrapper_class)
      result = n_label(attribute) + n_select_field(attribute, options) + error_field(attribute)
      n_attribute_wrapper(result, wrapper_class)
    end

    def file_field_with_label(attribute, options={})
      result = n_label(attribute) + n_file_field(attribute, options) + error_field(attribute) + error_field("#{attribute}_content_type") + error_field("#{attribute}_file_name") + error_field("#{attribute}_file_size")
      n_attribute_wrapper(result)
    end

    def password_field_with_label(attribute, options={})
      wrapper_class = options.delete(:wrapper_class)
      result = n_label(attribute) + n_password_field(attribute, options) + error_field(attribute)
      n_attribute_wrapper(result, wrapper_class)
    end

    def autocomplete_field_with_label(attribute, options={})
      result = n_label(attribute) + n_autocomplete_field(attribute, options)
      n_attribute_wrapper(result)
    end

    def spinner_submit
      result = []
      result << image_tag("spinner.gif", :class => "spinner")
      result << submit(:class => "button")
      content_tag(:div, result.join.html_safe)
    end

    def controller
    end

    def config
      @template.controller
    end

    private
    def error_field(attribute)
      content_tag(:div, object.errors[attribute].first, :class => "error") unless object.errors[attribute].empty?
    end

    def n_label(attribute)
      content_tag(:div,label(attribute), :class => "label")
    end
    
    def n_hint(message)
      content_tag(:div,message, :class => "hint") if message
    end

    def n_file_field(attribute, options)
      content_tag(:div, file_field(attribute, options), :class => "field")
    end

    def n_text_field(attribute, options)
      content_tag(:div, text_field(attribute, options), :class => "field")
    end

    def n_select_field(attribute, options)
      content_tag(:div, select(attribute, options), :class => "field")
    end

    def n_text_area(attribute, options)
      options.merge!({ :cols => nil, :rows => nil })
      content_tag(:div,text_area(attribute, options), :class => "field")
    end

    def n_password_field(attribute, options)
      hint = options.delete(:hint)
      result = password_field(attribute, options.merge(:autocomplete => "off")) + n_hint(hint)
      content_tag(:div,result, :class => "field")
    end

    def n_autocomplete_field(attribute, options)
      url = options.delete(:url)
      result = []
      result << autocomplete_field(attribute, url, :autocomplete => "off")
      result << n_spinner(attribute)
      content_tag(:div,result.join.html_safe, :class => "field")
    end
    
    def n_spinner(attribute)
      image_tag("spinner.gif", :class => "spinner", :id => "#{object_name}_#{attribute}_spinner")
    end

    def n_attribute_wrapper(result, wrapper_class = nil)
      wrapper_classes = [wrapper_class, "attribute"].join(" ").strip
      content_tag(:div, result, :class => wrapper_classes)
    end
  end
end