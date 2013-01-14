FactoryGirl.define do

  sequence(:name)   { |n| "Example #{n}" }
  sequence(:domain) { |n| "example#{n}" }  

  factory :account do
    created_at "2010-10-12 11:22:00"
    updated_at "2010-10-12 11:22:00"

    factory :example do
      name { generate(:name) }
      domain { generate(:domain) }
      active "true"
    end

    factory :dummy do
      name { generate(:name) }
      domain { generate(:domain) }
    end

    factory :other do
      name { generate(:name) }
      domain { generate(:domain) }
      active "false"
    end

    factory :deactivated do
      name { generate(:name) }
      domain { generate(:domain) }
      active "false"
    end
  end
end