require 'sidekiq/web'

Rails.application.routes.draw do

  post '/' => 'jobs#create', as: :create_job

  get '/status/:id' => 'jobs#status', as: :job_status
  get '/result/:id' => 'jobs#result', as: :job_result

  mount Sidekiq::Web => '/sidekiq'

end
