class Company < Entity
  attr_accessible :name, :photo, :delete_photo, :tag_list, :addresses_attributes, :emails_attributes, :phones_attributes, :websites_attributes, :permissions_attributes
  has_many :contacts
end
