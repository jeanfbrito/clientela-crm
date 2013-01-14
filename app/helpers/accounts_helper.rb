module AccountsHelper
  def error_for_field(form, field)
    content_tag(:div, form.object.errors[field].first, :class => "error") unless form.object.errors[field].empty?
  end
end