class Contact < Entity
  attr_accessible :name, :title, :company, :company_name, :photo, :delete_photo, :tag_list, :addresses_attributes, :emails_attributes, :phones_attributes, :websites_attributes, :permissions_attributes, :imported_by

  has_many :relationships, :dependent => :destroy
  has_many :tasks, :as => :taskable, :dependent => :destroy
  belongs_to :company
  belongs_to :imported_by, :class_name => 'ContactImport'
  validates :name, :presence => true
  # default_scope order('name asc')

  define_index do
    indexes name, title, emails.address, phones.number, addresses.street, addresses.city, addresses.state, addresses.zip, company.name
  end

  class << self
    def initials
      select('substr(name, 1,1) as initial').group(:initial).map {|c| c.initial }.sort
    end

    def autocomplete_title(term)
      unscoped { where(["LOWER(title) LIKE ?", "%#{term.downcase}%"]).limit(10).order("title ASC").select('distinct title') }
    end
  end

  def company_name=(name)
    self.company = Company.find_or_create_by_name(name) unless name.blank?
  end

  def company_name
    self.company && self.company.name
  end

  def delete_photo=(value)
    self.photo = nil if !!value
  end

  def deals
    @deals ||= relationships.on_deals.map(&:entity)
  end

  def facts
    @facts ||= relationships.on_facts.map(&:entity)
  end
end
