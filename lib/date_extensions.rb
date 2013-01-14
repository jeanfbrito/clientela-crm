module DateExtensions
  def this_week
    (0.days.from_now.end_of_week-2.days).to_date
  end

  def next_week
    (7.days.from_now.end_of_week-2.days).to_date
  end
end

Date.extend DateExtensions