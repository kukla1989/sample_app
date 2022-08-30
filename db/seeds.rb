# Create a main sample user.
User.create!(name: "roma",
             email: "roma@gmail.com",
             password: "kukla123",
             password_confirmation: "kukla123",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@gmail.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

#create 50 microposts for first 6 users
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 7)
  users.each { |user| user.microposts.create!(content: content) }
end

#create follow and followed relationships
users = User.all
user = User.first
following = users[2..50]
follows = users[3..40]
following.each { |followed| user.follow(followed) }
follows.each {|follower| follower.follow(user) }


