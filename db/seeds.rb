# 10.times do |n|
#   10.times do |n|
#     title = Faker::Pokemon.name
#     content = Faker::Pokemon.name
#     end_time_limit = Faker::Date.between(2.days.ago, Date.today)
#     status = Faker::Number.between(0, 2)
#     priority = Faker::Number.between(0, 2)
#
#     Task.create!(title: title,
#                  content: content,
#                  end_time_limit: end_time_limit,
#                  status: status,
#                  priority: priority,
#                  user_id: 1
#                  )
#   end
# end
#
# User.create!(name: "管理人",
#              email: "admin@dic.com",
#              password: "12345678",
#              admin: "true"
#             )
