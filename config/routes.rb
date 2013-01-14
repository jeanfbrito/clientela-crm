ClientelaMysql::Application.routes.draw do
  devise_for :users, :controllers => { :invitations => 'invitations' }

  match '/dashboard', :to => redirect("/")
  root :to => "dashboard#show"
  resources :menus, :only => [:create, :destroy]
  resource :welcome, :only => [:show, :update], :controller => :welcome
  resources :users, :except => [:new, :create, :show] do
    put :update_authentication_token, :on => :member
    put :survey, :on => :collection
  end

  resources :contacts do
    get :autocomplete_contact_name, :on => :collection
    get :autocomplete_contact_title, :on => :collection
    get :autocomplete_company_name, :on => :collection
    resource :subscription, :only => [:create, :destroy]
  end
  resources :tags, :only => [:index, :show] do
    resources :contacts, :only => [:index]
  end
  resources :notes, :only => [:create, :edit, :update, :destroy]
  resources :tasks, :except => [:show] do
    get 'completed', :on => :collection
    put 'complete', :on => :member
  end
  resources :facts do
    get 'closed', :on => :collection
    resource :subscription, :only => [:create, :destroy]
  end
  resources :deals do
    collection do
      get :prospect, :qualify, :proposal, :negotiation, :lost, :won
    end
    resource :subscription, :only => [:create, :destroy]
  end
  resources :companies, :only => [:edit, :update, :show] do
    resource :subscription, :only => [:create, :destroy]
  end
  resources :contact_imports do
    post 'revert', :on => :member
  end
  resources :relationships, :only => [:create, :destroy]
  resource :search, :only => [:show]

  resources :task_categories, :except => [:index, :show, :destroy]
  resources :groups, :except => [:show]

  if Rails.env.production?
    match '/campaigns' => "dashboard#soon", :as => :campaigns
  else
    resources :campaigns
  end

  match '/reports' => "reports#index"
  match '/surveys' => "dashboard#soon", :as => :surveys
  match '/support/api' => "support#api"
  match '/hooks/wufoo' => "hooks#wufoo", :via => :post
  
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
  
  # root :to => "dashboard#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
