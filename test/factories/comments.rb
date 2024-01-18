FactoryBot.define do
  factory :comment do
    # author { nil }
    # post { nil }
    # parent { nil }
    content { Faker::Lorem.paragraphs.join "\n" }
  end
end
