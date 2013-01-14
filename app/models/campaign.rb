class Campaign < ActiveRecord::Base
  STATUS = ["planned", "started", "completed", "hold", "canceled"]
  has_many :notes, :as => :notable
  has_many :tasks, :as => :taskable, :dependent => :nullify
  validates :name, :presence => true
  validates :status, :inclusion => STATUS
end