class FactsController < InheritedResources::Base
  respond_to :html, :xml, :json
  custom_actions :collection => :closed

  def index
    @facts = Fact.opened
    index!
  end

  def closed
    @facts = Fact.closed
    closed! do |format|
      format.html { render :index }
    end
  end
end
