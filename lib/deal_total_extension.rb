module DealTotalExtension
  def total
    all.inject(0){|sum, deal| sum += deal.total_value}
  end
end