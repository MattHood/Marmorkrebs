FactoryBot.define do
  factory :submitter, class: :User do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    username { Faker::Internet.username }
  end
  
  factory :post do
    submitter
    title { Faker::Lorem.sentence }
  end
end
