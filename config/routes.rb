Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "devise/users/registrations" }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "welcome#index"

  namespace :admin do
    resources :orders
    resources :categories
    resources :projects do
      resources :plans
      member do
        post :publish
        post :offline
      end
    end
    resources :projects_verify do
      member do
        post :pass_verify
        post :reject_verify
      end
    end
    resources :users do
      member do
        post :promote
        post :demote
      end
    end
    resources :bills do
      collection do
        get :show_bill_payments
        get :payout_index
        get :show_bill_payouts
        get :payments_index
        post :custom_fund_rate
      end
      member do
        post :show_bill_payments_by_project
        post :payout
      end
    end
    resources :users_verify do
      member do
        post :pass_verify
        post :reject_verify
      end
    end
  end

  namespace :account do
    resources :users do
      member do
        post :apply_for_certify
        post :send_verification_code
        get :show_verify_phone_number
        post :verify_phone_number
        get :change_password
      end
    end
    resources :projects do
      resources :posts
      resources :plans
      member do
        post :apply_for_verification
        post :offline
        post :reject_message
      end
    end
    resources :orders do
      member do
        post :pay_with_alipay
        post :pay_with_wechat
        post :show_orders_for_one_project
      end
    end
    resources :bills
  end

  resources :plans do
    resources :orders
  end

  resources :notifications do
    collection do
      post :mark_as_read
    end
  end

  resources :projects do
    resources :plans
    collection do
      get :search
    end
  end

end
