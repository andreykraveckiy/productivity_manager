namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_projects
    make_tasks
  end
end

def make_users
  3.times do |n|
    name = Faker::Name.name
    encrypted_password = User.new(:password => "password8").encrypted_password
    uid = ('0'..'1').to_a.shuffle[0..15].join
    email = "example-#{n+1}@railstutorial.org"
    User.create!(name: name,
                 encrypted_password: encrypted_password,
                 provider: "facebook",
                 uid: uid,
                 email: email,
                 password: "password8")
  end
end

def make_projects
  users = User.all
  3.times do
    name = Faker::Lorem.sentence(5)
    users.each { |user| user.projects.create!(name: name) }
  end
end

def make_tasks
  projects = Project.all
  3.times do
    content = Faker::Lorem.sentence(3)
    projects.each { |pr| pr.tasks.create!(content: content) }
  end
end