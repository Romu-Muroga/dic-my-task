require 'rails_helper'

RSpec.describe Label, type: :model do
  it "nameが101文字以上または空ならバリデーションが通らない" do
    label = Label.new(name: "")
    expect(label).not_to be_valid
    label = Label.new(name: "#{"a" * 101}")
    expect(label).not_to be_valid
  end
end
