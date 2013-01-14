class NoteObserver < ActiveRecord::Observer
  def after_create(note)
    Activity.create(:activitable => note, :action => "create", :parent => serialized_parent(note), :record => serialized_record(note))
    note.notable.subscribers.each do |subscriber|
      UserMailer.subscription_update(note, subscriber).deliver if subscriber != note.author
    end
  end

  def after_destroy(note)
    Activity.create(:activitable => note, :action => "destroy", :parent => serialized_parent(note), :record => serialized_record(note))
  end

  private
  def serialized_parent(note)
    { :name => note.notable.name,
      :type => note.notable.class.name.downcase,
      :id   => note.notable_id }
  end

  def serialized_record(note)
    { :content => note.content }
  end
end
