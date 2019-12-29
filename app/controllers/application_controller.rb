# frozen_string_literal: true

require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'superdupersecretword'
  end

  get '/' do
    if session[:user_id]
      redirect '/home'
    else
      erb :index
    end
  end

  get '/login' do
    if session[:user_id]
      redirect '/home'
    else
      erb :login
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "welcome back #{current_user.username}!"
      redirect '/home'
    else
      flash.now[:alert] = 'you shall not pass!'
      erb :login
    end
  end

  get '/logout' do
    session.clear
    flash[:alert] = "so long, farewell, auf wiedersehen, goodbye."
    redirect '/'
  end

  helpers do
    def logged_in?
      if !session[:user_id]
        flash[:alert] = "you need to be logged in to do that."
        redirect '/'
      end
    end

    def current_user
      User.find_by_id(session[:user_id])
    end

    def owns_movie?
      if current_user.id != @movie.user_id
        flash[:alert] = "you're not allowed to touch that"
        redirect '/'
      end
    end

  end
end
