# Create a main sample user.
User.create!(name: "roma",
             email: "roma@gmail.com",
             password: "kukla123",
             password_confirmation: "kukla123",
             admin: true)

User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar")

# Generate a bunch of additional users.
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@gmail.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end