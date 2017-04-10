TechReviewSite::Application.routes.draw do

  devise_for :users
#どの作品のレビューを作成するか、見るかを紐付けるため、ネストする
  resources :users, only: :show
  resources :products, only: :show do
    resources :reviews, only: [:new, :create]
  # get  'products/:product_id/reviews/new' => 'review#new'
  # post 'products/:product_id/reviews/'    => 'review#create'

  # resources :products, only: :show do
    collection do
      get 'search'
    end
  end
  root 'products#index'

end
