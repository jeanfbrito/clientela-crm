FactoryGirl.define do
  factory :entity do
    factory :entity_helabs do
      name "helabs"
      type "Company"
    end

    factory :entity_quentin do
      name "Quentin"
      type "Contact"
    end

    factory :entity_tabajara do
      name "Tabajara"
      type "Company"
    end
  end
end