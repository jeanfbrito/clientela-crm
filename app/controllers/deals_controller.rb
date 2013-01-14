class DealsController < InheritedResources::Base
  respond_to :html, :xml, :json
  respond_to :js, :only => [:update]
  load_and_authorize_resource :except => [:new, :index, :create]

  def index
    @pendings = Deal.accessible_by(current_ability).pending.uniq
    @wons = Deal.accessible_by(current_ability).won.uniq
    @losts = Deal.accessible_by(current_ability).lost.uniq
  end
  def prospect
    @deals = Deal.accessible_by(current_ability).prospect.uniq
    render 'index'
  end
  def qualify
    @deals = Deal.accessible_by(current_ability).qualify.uniq
    render 'index'
  end
  def proposal
    @deals = Deal.accessible_by(current_ability).proposal.uniq
    render 'index'
  end
  def negotiation
    @deals = Deal.accessible_by(current_ability).negotiation.uniq
    render 'index'
  end
  def won
    @deals = Deal.accessible_by(current_ability).won.uniq
    render 'index'
  end
  def lost
    @deals = Deal.accessible_by(current_ability).lost.uniq
    render 'index'
  end
end
