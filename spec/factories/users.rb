FactoryBot.define do
  factory :user, aliases: [:moderator] do
    sequence(:first_name) { |n| "first_#{n}" }
    sequence(:last_name) { |n| "last_#{n}" }
    sequence(:email) { |n| "test_#{n}@sample.com" }
    sequence(:phone) { 10.times.map { rand(10) }.join }
    lat { 28.631224 }
    lng { 77.219288 }
    password { 'password123' }
    password_confirmation { 'password123' }
    created_at { Time.zone.today }
    updated_at { Time.zone.today }
    user_type { 'user' }
  end
end
