# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Test User' }
    sequence(:email) { |n| "user#{n}@mailinator.com" }
    sequence(:mobile) { |n| "123456789#{n}" }
    password { 'password@123' }
    wallet_balance { 100 }
    auth_token { 'yEU27a78WEcH-sGWMeSs' }
  end
end
