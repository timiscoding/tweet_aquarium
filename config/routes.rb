Rails.application.routes.draw do
  root :to => 'fishies#fishTweets'
  get '/tweets' => 'fishies#tweets'
  get '/pages/:id' => 'fishies#pages'

end
