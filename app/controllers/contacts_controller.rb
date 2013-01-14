class ContactsController < InheritedResources::Base
  respond_to :html, :xml, :json
  respond_to :js, :only => [:index]
  autocomplete :company, :name, :full => true
  load_and_authorize_resource :except => [:new, :index, :create]

  def autocomplete_contact_name
     render :json => json_for_autocomplete(
      Contact.accessible_by(current_ability).where(["LOWER(name) LIKE ?", "%#{params[:term].downcase}%"]).limit(10).order("name ASC") , :name
     )
  end
  def autocomplete_contact_title
     render :json => json_for_autocomplete(Contact.autocomplete_title(params[:term]), :title)
  end

  protected  
  def collection
    @contacts ||= if params[:tag_id]
      @tag = ActsAsTaggableOn::Tag.find(params[:tag_id])
      end_of_association_chain.accessible_by(current_ability).group(group_by_data).tagged_with(@tag)
    elsif params[:initial]
      end_of_association_chain.accessible_by(current_ability).group(group_by_data).where(["name ilike ?", "#{params[:initial]}%"])
    else
      end_of_association_chain.accessible_by(current_ability).group(group_by_data)
    end.paginate(:page => params[:page])
  end
  def group_by_data
    "entities.id, entities.name, entities.title, entities.notes, entities.created_at, entities.updated_at, entities.photo_file_name, entities.photo_content_type, entities.photo_file_size, entities.photo_updated_at, entities.company_id, entities.imported_by_id, entities.type"
  end
end
