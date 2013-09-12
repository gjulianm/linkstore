Linkstore::Application.routes.draw do
  get "bookmarklet" => 'bookmarklet#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'links#list'
  get 'links/new' => 'links#new', :as => 'link_new'
  post 'links/new' => 'links#create', :as => 'link_create'
  post 'links/create'
  get 'links/create' => 'links#create_get'
  get 'links/list', :as => 'link_list'
  get 'links/rss', :as => 'link_rss'
  get 'links/rss/:id', to: 'link#rssauthor'
  get 'link/set_editor/:id' => 'links#set_editor'
  get 'link/release/:id' => 'links#release'
  get 'link/done/:id' => 'links#done'
  get 'links/bookmarklet'
  get 'user' => "user#index", :as => "user_set"
  post 'user' => 'user#set'
  post 'comments/create/:id' => 'comments#create', :as => 'comment_create'
end
