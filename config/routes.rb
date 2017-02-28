require 'api_constraints'

Rails.application.routes.draw do
  resources :event_logs

  resources :play_networks
  resources :play_nodes

  resources :play_invitations do
    member do
      post 'accept'
    end
    member do
      post 'reject'
    end
  end

  namespace :api, defaults: {format: :json} do
    scope module: :v2, constraints: ApiConstraints.new(version: 2, default: false) do
      devise_scope :user do
        match '/sessions' => 'sessions#create', :via => :post
        match '/sessions' => 'sessions#destroy', :via => :delete
      end

      resources :families
    end

    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      devise_scope :user do
        match '/sessions' => 'sessions#create', :via => :post
        match '/sessions' => 'sessions#destroy', :via => :delete
      end
      match '/sessions'  => 'status#index', :via => :get

      resources :families

      resources :infos
      match '/info' => 'infos#last', :via => :get
      resources :messages do
        match '/message/:id' => 'messages#confirm', :via => :post
      end

      resources :neighbors_families
      resources :neighbors_invitations

      resources :play_networks

      resources :friends
      resources :play_invitations
      match '/play_invitation' => 'play_invitations#last', :via => :get
      match '/accept_play_invitation/:id' => 'play_invitations#accept', :via => :post
      match '/cancel_play_invitation/:id' => 'play_invitations#cancel', :via => :post
      match '/decline_play_invitation/:id' => 'play_invitations#decline', :via => :post
      match '/accept_play_invitation' => 'play_invitations#accept', :via => :post
      match '/cancel_play_invitation' => 'play_invitations#cancel', :via => :post
      match '/decline_play_invitation' => 'play_invitations#decline', :via => :post
    end
  end

  devise_for :users
  resources :registrations do
    match '/registrations/:id/edit(.:format)' => 'registrations#edit', :via => :post
  end
  
  resources :infos
  resources :messages do
    match '/message/:id' => 'messages#confirm', :via => :post
  end

  resources :playcelets
  resources :children

  resources :apps
  resources :supervisors
  resources :parents

  resources :places
  resources :families

  resources :neighbors_families_links
  resources :neighbors_invitations
  resources :neighbors_families

  resources :delayed_jobs
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
  match '/delete_all_messages_data' => 'home#delete_all_messages_data', :via => :delete

  root 'home#index'
end
