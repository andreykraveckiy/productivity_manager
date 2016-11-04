FactoryGirl.define do 
  factory :user do
    name Faker::Name.name
    encrypted_password User.new(:password => "password8").encrypted_password
    provider "facebook"
    uid ('0'..'1').to_a.shuffle[0..15].join
    email Faker::Internet.email
    password "password8"
    password_confirmation "password8"
  end

  factory :project do
    sequence (:name) { |n| "Project #{n}" }
    user
  end

  factory :task do
    content "Some task"
    priority 0
    project
  end
end