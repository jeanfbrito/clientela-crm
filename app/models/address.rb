class Address < ActiveRecord::Base
  KINDS_FOR_CONTACT = %w{work home other}
  KINDS_FOR_COMPANY = %w{headquarters subsidiary office other}
  attr_accessible :street, :type, :city, :state, :zip, :kind
  validates :kind, :inclusion => (KINDS_FOR_CONTACT + KINDS_FOR_COMPANY)

  def line1
    street
  end

  def line2
    [city, state, zip].reject(&:blank?).join(", ")
  end

  def map_link
    "http://maps.google.com/maps?" + {:q => [street, city, state, zip].reject(&:blank?).join(", ")}.to_query
  end

  def self.kinds_for(model)
    model.is_a?(Contact) ? KINDS_FOR_CONTACT : KINDS_FOR_COMPANY
  end
end