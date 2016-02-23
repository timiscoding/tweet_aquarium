FactoryGirl.define do
  factory :user do |f|
    f.sequence(:name) { Faker::Name.name }
    f.sequence(:email) { Faker::Internet.email }
    # name Faker::Name.name
    # email Faker::Internet.email

    factory :user_with_tweets do
      after(:create) do |u| # like after_action/after_save in activerecord
        FactoryGirl.create_list(:tweet, Random.rand(10..50), :user => u)
      end
    end
  end

  factory :tweet do |f|
    # Client.search(args[:query], result_type: "recent", lang: "en").take(10).each do |tweet|
    #   f.sequence(:post) { tweet.full_text }
    # end
    f.sequence(:post) { Faker::Lorem.sentence }
    # post Faker::Lorem.sentence
  end
end