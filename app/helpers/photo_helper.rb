module PhotoHelper
  def small_thumb_tag(image)
    content_tag(:div, image_tag(image), :class => "avatar")
  end
  
  def small_photo_tag(record)
    photo_tag(record, :small)
  end

  def thumb_photo_tag(record)
    photo_tag(record, :thumb)
  end

  private
  def photo_tag(record, style)
    content_tag(:div, photo_image_tag(record, style), :class => "avatar")
  end

  def photo_image_tag(record, style)
    tag(:img, {:src => photo_url(record, style), :height => size(record, style), :width => size(record, style), :alt => record.name}, false, false)
  end

  def photo_url(record, style)
    if record.emails.empty?
      record.photo.url(style)
    else
      params = [[:s, size(record, style)], [:d, full_url_for(record.photo.url(style))]].collect {|i| "#{i[0]}=#{i[1]}"  }.join('&')
      "https://secure.gravatar.com/avatar/#{Digest::MD5.hexdigest(record.emails.first.address)}?#{params}"
    end
  end

  def full_url_for(image)
    "#{request.protocol}#{request.host_with_port}#{image}"
  end

  def size(record, style)
    record.class.attachment_definitions[:photo][:styles][style].first.sub('#', '').split('x')[0]
  end
end