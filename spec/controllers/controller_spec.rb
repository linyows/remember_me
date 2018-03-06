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

describe ApplicationController, type: :controller do
  controller do
    def index
      redirect_to '/' and return if user_signed_in?
    end

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

  let(:remember_me) { true }
  let(:user) { User.new }

  describe 'GET #index' do
    context 'remember' do
      before do
        expect(User).to receive(:where).and_return([user])
        expect(user).to receive(:remember_expired?).and_return(false)
        expect(controller).to receive_message_chain(:cookies, :signed, :[]).and_return([user.id, Digest::SHA1.hexdigest(user.id)])
        get :index
      end

      it { expect(response).to redirect_to('/') }
    end

    context 'raise error' do
      before do
        request.env['HTTP_ACCEPT'] = 'anonymous/html'
        expect(controller).to receive_message_chain(:cookies, :signed, :[]).and_raise(NameError)
        get :index
      end

      it { expect(response).not_to redirect_to('/') }
    end
  end

  describe 'POST #create' do
    before do
      expect(controller).to receive_message_chain(:cookies, :signed, :[]=).and_return('')
      post :create, params: { remember_me: remember_me }
    end

    it { expect(response).to redirect_to('/') }
  end

  describe 'GET #destroy' do
    before do
      expect(controller).to receive(:current_user).and_return(User.new)
      expect(controller).to receive_message_chain(:cookies, :delete).and_return(nil)
      delete :destroy, params: {id: user.id}
    end

    it { expect(response.status).to eq 302 }
  end
end
