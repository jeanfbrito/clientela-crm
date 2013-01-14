FactoryGirl.define do
  sequence(:email)  { |n| "email#{n}@example.com" }
  sequence(:token) { |n| "this-is-my-authentication_token#{n}" }

  factory :user do
    name "Username"
    email { generate(:email) }
    password "123456"
    password_confirmation "123456"

    factory :admin do
      admin true
    end

    factory :quentin do
      name "Quentin Tarantino"
      email { generate(:email) }
      encrypted_password "$2a$10$SnE5/xMXr.1VU7W12W2Ae.9hNm/GTY9E7CKlXi4hqmX2cPWJ5GRji"
      dropbox_token "abcdef"
      authentication_token { generate(:token) }
      admin "true"
    end

    factory :fake do
      name "Fake User"
      email "fake@example.com"
      encrypted_password "$2a$10$SnE5/xMXr.1VU7W12W2Ae.9hNm/GTY9E7CKlXi4hqmX2cPWJ5GRji"
      authentication_token { generate(:token) }
    end
  end
end