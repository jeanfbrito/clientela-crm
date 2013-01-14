class DealObserver < ActiveRecord::Observer
  def after_create(deal)
    Activity.create(params(deal).merge(:action => "create"))
  end

  def before_update(deal)
    Activity.create(params(deal).merge(:action => deal.status.to_sym)) if deal.status_changed?
  end

  def after_destroy(deal)
    Activity.create(params(deal).merge(:action => "destroy"))
  end
  
  private
  def params(deal)
    {:activitable => deal, :record => {:name => deal.name, :type => "deal", :id => deal.id}}
  end
end
