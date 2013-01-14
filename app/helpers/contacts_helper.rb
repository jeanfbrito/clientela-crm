module ContactsHelper
  def initials?
    !params[:tag_id] && !params[:scope]
  end
end