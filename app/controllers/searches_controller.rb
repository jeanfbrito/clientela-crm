class SearchesController < ApplicationController
  def show
    @searches = ThinkingSphinx.search(params[:q], :retry_stale => true)
    redirect_to @searches.first if @searches.size == 1
  end
end
