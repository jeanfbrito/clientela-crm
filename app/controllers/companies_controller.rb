class CompaniesController < InheritedResources::Base
  respond_to :html, :xml, :json
  actions :edit, :show, :update

  def update
    update! { params[:referer] || @company }
  end
end
