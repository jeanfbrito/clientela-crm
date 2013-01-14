module DealsHelper
  def checked(deal, status)
    return "checked" if deal.status.to_sym == status.to_sym
  end

  def formated_bid(deal)
    return if !(!deal.value.blank? && deal.value_type) || deal.value.zero?
    content_tag(:p, t("deals.common.#{deal.value_type}_bid", :value => number_to_currency(deal.value), :duration => deal.duration, :total => number_to_currency(deal.value*deal.duration.to_i)))
  end
end