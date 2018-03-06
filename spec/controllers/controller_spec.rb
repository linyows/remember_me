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

describe SessionsController, type: :controller do
  let(:remember_me) { true }

  describe 'POST #create' do
    before do
      expect(controller).to receive_message_chain(:cookies, :signed, :[]=).and_return('')
      post :create, params: { remember_me: remember_me }
    end

    it { expect(response.status).to eq 302 }
  end

  describe 'GET #destroy' do
    before do
      expect(controller).to receive(:current_user).and_return(User.new)
      expect(controller).to receive_message_chain(:cookies, :delete).and_return(nil)
      get :destroy
    end

    it { expect(response.status).to eq 302 }
  end
end
