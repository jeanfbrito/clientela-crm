class MoveDealContactToRelationship < ActiveRecord::Migration
  def self.up
    Deal.all.each do |deal|
      if deal.contact_id
        Relationship.create!(:entity => deal, :contact_id => deal.contact_id)
      end
    end

    remove_column :deals, :contact_id
  end

  def self.down
    add_column :deals, :contact_id, :integer
  end
end
