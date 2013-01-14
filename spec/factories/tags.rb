FactoryGirl.define do
  sequence(:id)  { |n| "#{n}" }

  factory :tag, class: ActsAsTaggableOn::Tag do
    id { generate(:id) }
    
    factory :tag_owner do
      name "Owner"
    end
    factory :tag_partner do
      name "Partner"
    end
  end
end