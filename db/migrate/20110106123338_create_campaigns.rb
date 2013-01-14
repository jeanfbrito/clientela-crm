class CreateCampaigns < ActiveRecord::Migration
  def self.up
    create_table :campaigns, :force => true do |t|
      t.string    :name
      t.datetime  :start_date
      t.datetime  :end_date
      t.string    :status
      t.text      :description
      t.integer   :budget
    end
  end

  def self.down
    drop_table :campaigns
  end
end
