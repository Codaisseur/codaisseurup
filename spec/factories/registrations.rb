FactoryGirl.define do
  factory :registration do
    price           "9.99"
    status          "pending"
    guests_count    2

    user            { build(:user) }
    event           { build(:event) }
  end
end
