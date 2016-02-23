namespace :twitter do
  desc "Empties out the user and tweet tables from the DB"
  task :clear => :environment do # depends on environment task, which runs rails server before doing task
    User.destroy_all
    Tweet.destroy_all
  end

  desc "Creates fake users and fake tweets"
  task :posts, [:user_count] => :environment do |t, args| # arg user_count will be inside args
    puts "Creating users and tweets: #{ args[:user_count] }"
    FactoryGirl.create_list :user_with_tweets, args[:user_count].to_i
  end

  desc "Searches twitter for limit number of tweets container query"
  task :search, [:query, :limit] => :environment do |t, args|
    # Dont bother creating users, just fetch the tweets and shove them in the DB

    $client.search(args[:query], result_type: "recent", lang: "en").take(args[:limit].to_i).each do |tweet|
      Tweet.create :post => tweet.full_text
    end
  end
end