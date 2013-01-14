class MenusController < ApplicationController
  respond_to :html
  
  def create
    @menu = Menu.create(params[:menu])

    respond_with(@task) do |format|
      format.html { redirect_to(:back) }
    end
  end

  def destroy
    @menu = Menu.find(params[:id])
    @menu.destroy

    respond_with(@task) do |format|
      format.html { redirect_to(:back) }
    end
  end
end
