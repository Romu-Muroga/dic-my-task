FactoryBot.define do
  
  factory :user do
    name { "test_user_01" }
    email { "test_user_01@dic.com" }
    password { "password" }
  end

  factory :second_user, class: User do
    name { "test_user_02" }
    email { "test_user_02@dic.com" }
    password { "password" }
  end

  factory :third_user, class: User do
    name { "test_user_03" }
    email { "test_user_03@dic.com" }
    password { "password" }
  end
end
