FactoryGirl.define do
  factory :tagging, class: ActsAsTaggableOn::Tagging do
    factory :tag_owner_quentin do
      taggable_type "Entity"
      context "tags"
      created_at { 2.days.ago }
    end
    factory :tag_partner_joseph do
      taggable_type "Entity"
      context "tags"
      created_at { 2.days.ago }
    end
  end
end