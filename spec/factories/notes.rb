FactoryGirl.define do
  factory :note do
    factory :note_quentin do
      content "Quentin note"
      notable { FactoryGirl.create(:contact_quentin) }
      author { FactoryGirl.create(:quentin) }
      created_at { 1.day.from_now.to_s }
      updated_at { 1.day.from_now.to_s }
    end
    factory :note_helabs do
      content "Helabs note"
      notable { FactoryGirl.create(:company_helabs) }
      author { FactoryGirl.create(:quentin) }
      created_at { 1.day.from_now.to_s }
      updated_at { 1.day.from_now.to_s }
    end
    factory :note_quentin_deal_won do
      content "Quentin deal won"
      notable { FactoryGirl.create(:quentin_deal_won) }
      author { FactoryGirl.create(:quentin) }
      created_at { 1.day.from_now.to_s }
      updated_at { 1.day.from_now.to_s }
    end
    factory :note_service_order do
      content "My first service order note"
      notable { FactoryGirl.create(:fact) }
      author { FactoryGirl.create(:quentin) }
      created_at { 1.day.from_now.to_s }
      updated_at { 1.day.from_now.to_s }
    end
  end
end