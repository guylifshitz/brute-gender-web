Rails.application.routes.draw do

  devise_for :users

  require 'sidekiq/web'
  mount Sidekiq::Web => 'admin/sidekiq'

  # get :about, path: "a-propos", controller: "pages"
  # get 'welcome/index'
  get 'search', controller: "search"
  post 'search/results', controller: "search"
  get 'search/external', controller: "search"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'categories#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  resources :words do 
    member do
      put 'add'
    end
  end

  resources :word_scores

  resources :user_words do 
    member do
      put 'remove'
    end
  end

  resources :categories do
    post 'find_words', :on => :collection
    post 'update_range', :on => :collection
    post 'update_range', :on => :collection
    post 'create_levels'
    post :create_wrong_words_level
    resources :levels
  end

  resources :category_words do
    post 'disable'
    post 'enable'
  end

  resources :user_level_categories, controller: 'level_categories', type: 'UserCategory' 

  resources :level_instances do
    resources :run, controller: 'level_instances/run'

    get 'finished', to: 'level_instances#finished'

    post 'select_masculine', to: 'level_instances#select_masculine'
    post 'select_feminine', to: 'level_instances#select_feminine'

  end

  resources :users do
    resource :user_configuration do
      post 'enable_microphone', to: 'user_configurations#enable_microphone'
      post 'disable_microphone', to: 'user_configurations#disable_microphone'

      post 'enable_sound', to: 'user_configurations#enable_sound'
      post 'disable_sound', to: 'user_configurations#disable_sound'

      post 'enable_speak', to: 'user_configurations#enable_speak'
      post 'disable_speak', to: 'user_configurations#disable_speak'
    end
  end



  # resource :level_instance do
  #   post :create_wrong_words_level
  # end


  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
