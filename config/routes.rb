Rails.application.routes.draw do
  
  root 'questions#start'
  resources :questions, only: [:show] do
    get :start, on: :collection
    post :start_quiz, on: :collection
    post :submit, on: :member
    get :finish, on: :collection
    post :reload, on: :collection
    post :repeat, on: :collection
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
