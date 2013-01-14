class NotesController < InheritedResources::Base
  respond_to :html, :xml, :json
  respond_to :js, :only => :destroy  
  actions :all, :except => [ :index, :new, :show ]

  def create
    @note = Note.new(params[:note].merge({:author => current_user}))

    create! do |format|
      format.html { redirect_to @note.notable }
    end
  end

  def destroy
    destroy! { @note.notable }
  end

  def update
    update! { @note.notable }
  end
end
