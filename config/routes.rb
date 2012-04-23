CS169CampusScheduler::Application.routes.draw do
  resources :groups

  resources :preferences

  resources :time_off_requests

  resources :time_edits

  resources :substitutions

  resources :calendars

  match 'logout' => 'users#logout', :as => :logout
  scope '/admin' do
    resources :periods
    resources :users
<<<<<<< HEAD
    resources :groups
=======
    resources :labs  
>>>>>>> 005117369ecb9edb4faf4f65320558c8fc6d45ed
    match '/calendars' => 'calendars#admin'
  end

  match '/take_or_assign_subs' => 'substitutions#take_or_assign_subs'
  match "/changeAdmin" => "users#changeAdmin"
  match "/test_setuser/:id" => "users#test_setuser"
  match "/admin/groups/:id/add" => "groups#addUsers"
  put "/admin/groups/:id/add" => "groups#updateUsers"
  match "/admin/users/:user_id/Groups/:group_id/remove" => "users#removeGroup"
  match "/admin/users/:id/add" => "users#addGroup"


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'calendars#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
