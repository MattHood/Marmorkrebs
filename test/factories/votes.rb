FactoryBot.define do
  factory :vote do
    type { 1 }
    reference { 1 }
    voter { nil }
  end
end
