FactoryGirl.define do
  factory :user do
    provider         { ['google', 'facebook'].sample }
    uid              { Faker::Internet.slug }
    name             { Faker::Name.name }
    oauth_token      { Faker::Internet.password }
    oauth_expires_at { DateTime.tomorrow }
    email            { Faker::Internet.email }
    image_url        { Faker::Internet.url }
    image            { SecureRandom.base64 }
    gender           { Faker::Internet.email }
    locale           { ['male', 'female'].sample }
  end
end
