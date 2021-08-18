20.times do |index|
  User.create!(email: "useremail#{index}@gmail.com",
              name: "Username #{index}",
              password: "111111",
              password_confirmation: "111111")
end
