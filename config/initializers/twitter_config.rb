Rails.application.config.after_initialize do
  # define a constant throughout the scope of your application
  $client = Twitter::REST::Client.new do |config|
    config.consumer_key        = "rLFQylxabkyyVQ8NuOPAg4JiV"
    config.consumer_secret     = "91kDeyhnTDiTV46O0abwvi5tUm7UrwYct7E3O10SvFinf8amqW"
  end
end