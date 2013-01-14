module FormsHelper
  def remove_child_link(name, f)
    f.hidden_field(:_destroy) + link_to(name, "javascript:void(0)", :class => "remove_child")
  end
  
  def add_child_link(name, association)
    link_to(name, "javascript:void(0)", :class => "add_child", :"data-association" => association)
  end
  
  def new_child_fields_template(form_builder, association, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(association).klass.new
    options[:partial] ||= association.to_s.singularize
    options[:form_builder_local] ||= :f
    
    content_tag(:div, :id => "#{association}_fields_template", :class => "template", :style => "display: none") do
      form_builder.fields_for(association, options[:object], :child_index => "new_#{association}") do |f|
        render(:partial => "entities/#{options[:partial]}", :locals => {options[:form_builder_local] => f})
      end
    end
  end

  def options_with_translation(options)
    options.map do |option|
      [t(".#{option}"), option]
    end
  end

  def nested_attribute(f, attribute)
    result = []
    fields_container = []
    singular_attribute = attribute.to_s.singularize

    fields_container << f.fields_for(attribute) do |ff|
      fields_container << render(:partial => "entities/#{singular_attribute}", :locals => { :f => ff })
    end

    result << content_tag(:div,f.label(attribute), :class => "label")
    result << content_tag(:div, fields_container.join.html_safe, :class => "field fields-container", :id => "#{attribute}-fields")

    result << content_tag(:p, add_child_link(t("entities.form.new_#{singular_attribute}"), attribute))
    result << new_child_fields_template(f, attribute)

    content_tag(:div, result.join.html_safe, :class => "multiple attribute")
  end

  def spinner_submit_with_cancel(f)
    result = []
    result << spinner_submit(f)
    result << t("common.or")
    result << link_to(t("common.cancel"), url_for(:back))
    content_tag(:div, result.join(' ').html_safe, :class => "actions")
  end

  def spinner_submit(f)
    result = []
    result << image_tag("spinner.gif", :class => "spinner")
    result << f.submit(:class => "button")
    result.join.html_safe
  end
end