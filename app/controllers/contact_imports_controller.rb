class ContactImportsController < InheritedResources::Base
  respond_to :html, :xml, :json

  def revert
    @contact_import = ContactImport.find(params[:id])
    @contact_import.revert!
    redirect_to(@contact_import)
  end
end
