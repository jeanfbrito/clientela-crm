FactoryGirl.define do
  factory :contact_import do
    factory :joseph_import do
      imported_at { 1.day.ago } 
      file { File.open("#{Rails.root}/spec/fixtures/contact_imports/simple-5-contacts.csv-file") }
      kind "regular"
    end
  end
end