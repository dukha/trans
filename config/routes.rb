Translator::Application.routes.draw do
  

  #resources :calmapp_versions_translation_languages

  scope "/:locale" do
   resources :profiles
   #devise_for :users
   
   resources :translations_uploads
   # root will check permission and if ok redirect to whiteboards
   #root :to => "whiteboards#index"
   root :to => "permissions#select" 

   scope "/auth_user/:user_id" do
      resources :permissions
      get '/permissions_select' => 'permissions#select',      :as => :permissions_select, via: :all
      get '/set_permission/:id' => 'permissions#set_current', :as => :set_permission, via: :all
   end
   
   get '/auth_user/set_permission_by_ajax' => 'permissions#set_current_by_ajax', :as => :set_permission_by_ajax, via: :all
   get '/users_select' => 'users#select',      :as => :users_select, via: :all
    
   devise_for :users
   
   get "users/:id/edit_password",   :to => "users#edit",   :as => :edit_password  
    patch "users/:id/update_password", :to => "users#update", :as => :update_password  
    # for unlocking another user
    patch "users/:id/unlock_user",     :to => "users#unlock_user", :as => :unlock_user  
   resources :languages

   resources :whiteboard_types
   resources :whiteboards
   #resources :location_tree, :only => [:index, :show]
   #resources :locations
   #resources :areas

    resources :translation_languages

    #resources :organisations

    #resources :servers
   # to create a new child we need the parent_id
    #get '/organisations/new/:parent_id(.:format)' => 'organisations#new', :as => :new_child_organisation, via: :all
    #get '/translation_languages/new/:parent_id(.:format)' => 'translation_languages#new', :as => :new_child_translation_language, via: :all
    #get '/areas/new/:parent_id(.:format)' => 'areas#new',                 :as => :new_child_area, via: :all
    #get '/servers/new/:parent_id(.:format)' => 'servers#new',             :as => :new_child_server, via: :all
    
   resources :calmapps
   resources :calmapp_versions
   resources :release_statuses
   resources :redis_databases
   resources :redis_instances
   get 'unused_redis_database_indexes' => 'redis_instances#unused_redis_database_indexes', :as => 'redis_databases_getunused', via: :all
   get 'next_unused_redis_database_index'=> 'redis_instances#next_redis_database_index'  , :as => 'redis_databases_getnextindex', :via=> :all
   resources :user_works#, :only=>[:edit, :show]
   resources :calmapp_versions_translation_languages
   resources :translations #, :except=>:show#, :only=> [:new, :index]
   get "translations/dev_new" => "translations#dev_new", :as => "dev_new_translation", via: :all
   get "translations/dev_create" => "translations#dev_create", :as => "dev_create_translation", via: :all
   #match "translations_editable_list" => "translations#editable_list", :as => "translators_index"
   #match "redis_translations/edito" => "redis_translations#edito", :as => "edito_translation"
   resources :translation_parameters, :only=> [ :new, :index]
   #match "translation_parameters/save" => "translation_parameters#save", :as => "save_translation_params"
   #resources :uploads
   get "translations_uploads/file_to_redis/:id" => "translations_uploads#file_to_redis", :as => "to_redis", via: :all
   get "translations_uploads/select_translation_to_redis/:id" => "translations_uploads#select_translation_to_redis", :as => "select_to_redis", via: :all

   get "translations_uploads/write_yaml_file_to_db/:id" => "calmapp_versions_translation_languages#write_file_to_db", :as=> "write_yaml_file_to_db", :via => :all

   get "redis_databases/redis_to_yaml/:id" => "redis_databases#redis_to_yaml", :as => "redis_to_yaml", via: :all
   
   get "calmapp_version/version_alterwithredisdb/:id" => "calmapp_versions#version_alterwithredisdb", :as => "version_alterwithredisdb", via: :all
   
   resources :translation_editor_params

   resources :translation_editors
   #get "calmapps/all_in_one_new/" => "calmapps#all_in_one_new", :as => "all_in_one_new"
   #get "calmapps/all_in_one_create" => "calmapps#all_in_one_create"
   #match "upload"

   get '/contact', :to => 'static_pages#contact'
   get '/about',   :to => 'static_pages#about'
   get '/help',    :to => 'static_pages#help' 
  end
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
