require 'iconv'
class ContactImport < ActiveRecord::Base
  KINDS = %w(highrise regular)
  has_attached_file :file, url: :path_to_url

  validates_attachment_content_type :file, :content_type => ['application/octet-stream', 'text/plain', 'text/csv'], :message => lambda{I18n.t('activerecord.errors.models.contact_import.attachment_content_type')}
  validates_attachment_size :file, :less_than => 10.megabytes, :message => lambda{I18n.t('activerecord.errors.models.contact_import.attachment_size')}
  validates_attachment_presence :file, :message => lambda{I18n.t('activerecord.errors.models.contact_import.attachment_presence')}
  validates :kind, :inclusion => { :in => KINDS }
  has_many :imported_contacts, :class_name => 'Contact', :foreign_key => :imported_by_id
  after_create :enqueue_import

  def revert!
    imported_contacts.destroy_all
  end

  def execute!
    # Name, Email, Phone, Title, Company, Site, Tag
    log = []

    file_content = File.open(file.path).read
    begin
      csv_content = CSV.parse(file_content)
    rescue ArgumentError => e
      log << I18n.t("contact_imports.parse_error", :message => e.message)
      csv_content = CSV.parse(Iconv.iconv('UTF-8', 'UTF-16LE', file_content)[0])
    end

    csv_content.each_with_index do |row, i|
      row.each do |r|
        r.strip! rescue nil
      end

      if contact = find_contact_by_email(row[1])
        contact.name = row[0]
        contact.title = row[3]
        contact.company_name = row[4]

        if !row[2].blank? && contact.phones.where(:number => row[2]).blank?
          contact.phones.build({:number => row[2], :kind => "work"})
        end

        if !row[5].blank? && contact.websites.where(:url => row[5]).blank?
          contact.websites.build({:url => row[5], :kind => "work"})
        end

        unless row[6].blank?
          if !contact.tag_list.include?(row[6])
            contact.tag_list << row[6]
          end
        end
      else
        contact = Contact.new(
          :name => row[0],
          :emails_attributes => [{:address => row[1], :kind => "work"}],
          :phones_attributes => [{:number => row[2], :kind => "work"}],
          :title => row[3],
          :company_name => row[4],
          :websites_attributes => [{:url => row[5], :kind => "work"}],
          :tag_list => row[6],
          :imported_by => self)
      end

      begin
        contact.save!
      rescue => e
        log << I18n.t("contact_imports.log", :line => i+1, :message => e.message)
      end

    end
    update_attributes(:imported_at => DateTime.now, :log => log.join("\n"))
  end

  def execute_highrise!
    log = []

    file_content = File.open(file.path).read
    csv_content = CSV.parse(file_content)

    csv_content.delete_at(0) #remove header
    csv_content.each_with_index do |row, i|
      row.each do |r|
        r.strip! rescue nil
      end

      if row[0] == "Person"
        attributes = { :name => row[1],
          :title => row[5],
          :company_name => row[4],
          :imported_by => self
          }

        if !row[24].blank?
          row[24].split(",").each do |phone|
             attributes.merge!({:phones_attributes => [{:number => phone.strip!, :kind => "work"}]})
          end
        end

        if !row[30].blank?
          attributes.merge!({:emails_attributes => [{:address => row[30], :kind => "work"}]})
        end

        contact = Contact.new(attributes)
        contact.save!
      else
         attributes = {
           :name => row[1],
           :title => row[4],
           :tag_list => row[7],
           :addresses_attributes => [{:street => row[8], :city => row[9], :state => row[10], :kind => "work"}],
           :emails_attributes => [{:address => row[30], :kind => "work"}],
           :websites_attributes => [{:url => row[33], :kind => "work"}]
        }

        if !row[23].blank?
          row[23].split(",").each do |phone|
             attributes.merge!({:phones_attributes => [{:number => phone.strip!, :kind => "work"}]})
          end
        end

        company = Company.new(attributes)
        company.save!
      end
    end
    update_attributes(:imported_at => DateTime.now, :log => log.join("\n"))
  end

  @queue = :imports
  def self.perform(account_id, contact_import_id)
    Account.configure_by_id(account_id)
    contact_import = find(contact_import_id)
    if contact_import.kind == "highrise"
      contact_import.execute_highrise!
    else
      contact_import.execute!
    end
  end

  private
  def find_contact_by_email(email)
    email = Email.where(:address => email).first
    email && email.entity
  end

  def enqueue_import
    Resque.enqueue(ContactImport, Account.current.id, self.id)
  end

  def path_to_url
    "/system/accounts/contact_imports/:attachment/:id/:filename"
  end
end
