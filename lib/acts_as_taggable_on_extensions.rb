module ActsAsTaggableOn
  class Tag
    def to_param
      "#{id}-#{Permalink.make(name)}"
    end

    def self.group_by_initial(tags)
      tags.group_by {|t| t.name.chars.first}.sort
    end
  end
end

module ActsAsTaggableOnExtensions
  def acts_as_taggable_with_grouped_by_initial
    acts_as_taggable

    has_many :tags, :through => :tag_taggings, :source => :tag, :class_name => "ActsAsTaggableOn::Tag" do
      def grouped_by_initial
        ActsAsTaggableOn::Tag.group_by_initial(all)
      end
    end

    def self.tags_grouped_by_initial
      ActsAsTaggableOn::Tag.group_by_initial(tag_counts)
    end
  end
end

ActiveRecord::Base.extend ActsAsTaggableOnExtensions