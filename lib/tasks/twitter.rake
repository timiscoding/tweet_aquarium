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

  desc "get tweets for a user"
  task :from, [:user, :limit] => :environment do |t, args|
    @limit = args[:limit].to_i

    def collect_with_max_id(collection=[], max_id=nil, &block)
      response = yield(max_id)
      collection += response

      @limit -= collection.count
      if @limit > 0 then # haven't got enough tweets yet
        collect_with_max_id(collection, response.last.id - 1)
      else
        collection.flatten
      end
    end

    # twitter gem api only gets 20 at a time so we need to keep
    # calling it until we get the amount of tweets we want
    def get_all_tweets(user)
      collect_with_max_id do |max_id|
        options = {count: @limit, include_rts: true}
        options[:max_id] = max_id unless max_id.nil?
        $client.user_timeline(user, options)
      end
    end

    get_all_tweets(args[:user]).each do |tweet|
      Tweet.create :post => tweet.full_text
    end
  end
end