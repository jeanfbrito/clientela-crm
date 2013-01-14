class TagsController < ApplicationController
  def index
    tags = ActsAsTaggableOn::Tag.joins(:taggings).all.uniq.group_by {|t| t.name.chars.first}.sort
    @first_half = tags[0..((tags.size.to_f/2).ceil) - 1]
    @second_half = tags[((tags.size.to_f/2).ceil)..-1]
  end
  
  def show
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @contacts = Contact.tagged_with(@tag)
    @deals = Deal.tagged_with(@tag)
    @companies = Company.tagged_with(@tag)
  end
end
