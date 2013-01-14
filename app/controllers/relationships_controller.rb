class RelationshipsController < InheritedResources::Base
  respond_to :html, :xml, :json
  actions :create, :destroy
  
  def create
    create! { resource.entity }
  end

  def destroy
    destroy! { resource.entity }
  end
end