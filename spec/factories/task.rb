# 「FactoryBotを使用します」という記述
FactoryBot.define do

  # 作成するテストデータの名前を「task」とします
  # （実際に存在するクラス名と一致するテストデータの名前をつければ、そのクラスのテストデータを自動で作成します）
  factory :task do
    title { "test_task_01" }
    content { "test" }
    end_time_limit { DateTime.now }
    status { 0 }
    priority { 0 }
    user {}
  end

  # 作成するテストデータの名前を「second_task」とします
  # （存在しないクラス名の名前をつける場合、オプションで「このクラスのテストデータにしてください」と指定します）
  factory :second_task, class: Task do
    title { "test_task_02" }
    content { "sample" }
    end_time_limit { DateTime.tomorrow }
    status { 0 }
    priority { 1 }
    user {}
  end

  factory :third_task, class: Task do
    title { "test_task_03" }
    content { "japan" }
    end_time_limit { DateTime.now.since(3.days) }#3日後
    status { 0 }
    priority { 2 }
    user {}
  end
end
