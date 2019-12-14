require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "superdupersecretword"
  end

  get "/" do
    erb :index
  end

  get '/signup' do
    if logged_in?
      redirect '/home'
    else
      erb :signup
    end
  end

  post '/signup' do
    user = User.new(username: params[:username], password: params[:password])
		if user.save
      session[:user_id] = user.id
			redirect '/home'
		else
      flash[:message] = "This username is already taken"
      erb :signup
			#redirect "/failure"
		end
  end

  get '/login' do
    if logged_in?
      redirect '/home'
    else
      erb :login
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/home'
    else
      redirect '/failure'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/failure' do
    erb :failure
  end

  helpers do

    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find_by_id(session[:user_id])
    end

  end

end
