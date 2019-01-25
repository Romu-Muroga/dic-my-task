FactoryBot.define do
  factory :label do
    name { "dive_into_code" }
  end

  factory :second_label, class: Label do
    name { "仕事" }
  end

  factory :third_label, class: Label do
    name { "家事" }
  end
end
