class AccountController < ApplicationController
  before_action :authenticate_user!
  layout "user", :except => :show
end