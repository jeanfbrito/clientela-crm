FactoryGirl.define do

  factory :contact do
    factory :contact_joseph do
      name "Joseph"
      company_id { FactoryGirl.create(:company_tabajara).id }
      imported_by_id { FactoryGirl.create(:joseph_import).id }
      type "Contact"
    end

    factory :contact_quentin do
      name "Quentin"
      type "Contact"
    end
  end
end