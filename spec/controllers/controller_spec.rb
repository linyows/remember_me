require 'helper'

class ApplicationController < ActionController::Base
  include RememberMe::Controller
  include Rails.application.routes.url_helpers

  def current_user
    @current_user ||= session[:user_id] ? User.find(session[:user_id]) : remember('user')
  end

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.present? ? user.id : nil
  end

  def authenticate_user!
    redirect_to signin_path unless current_user
  end

  def user_signed_in?
    !!current_user
  end
end

class SessionsController < ApplicationController
  def create
    current_user = User.new
    remember_me(current_user) if remember_me?
    redirect_to '/'
  end

  def destroy
    forget_me(current_user)
    self.current_user = nil
    redirect_to '/signin'
  end
end

class HomesController < ApplicationController
  before_action :authenticate_user!

  def index
    render nothing: true
  end
end

describe SessionsController do
  let(:remember_me) { true }
  let(:attrs) { { remember_me: remember_me } }

  describe 'POST #create' do
    before do
      controller.stub_chain(:cookies, :signed, :[]=) { '' }
      post :create, attrs
    end

    it { response.status.should eq 302 }
  end

  describe 'GET #destroy' do
    before do
      controller.stub(:current_user) { User.new }
      controller.stub_chain(:cookies, :delete) { nil }
      get :destroy
    end

    it { response.status.should eq 302 }
  end
end
