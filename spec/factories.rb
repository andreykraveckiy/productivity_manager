FactoryGirl.define do 
  factory :user do
    name Faker::Name.name
    encrypted_password User.new(:password => "password8").encrypted_password
    provider "facebook"
    uid ('0'..'1').to_a.shuffle[0..15].join
    email Faker::Internet.email
    password "password8"
  end

  factory :project do
    name "My first project"
    user
  end
end