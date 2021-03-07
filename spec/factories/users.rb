FactoryBot.define do
  factory :user, aliases: [:moderator] do
    sequence(:first_name) { |n| "first_#{n}" }
    sequence(:last_name) { |n| "last_#{n}" }
    sequence(:email) { |n| "test_#{n}@sample.com" }
    sequence(:phone) { |n| "111111111#{n}" }
    password { 'password123' }
    password_confirmation { 'password123' }
    created_at { Time.zone.today }
    updated_at { Time.zone.today }
    user_type { 'user' }
  end
end
