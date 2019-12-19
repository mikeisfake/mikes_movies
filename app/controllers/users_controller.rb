require "pry"

class UsersController < ApplicationController

  include Quotable

  get '/signup' do
    if session[:user_id]
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
      flash.now[:message] = "i'm sorry dave. i'm afraid i can't do that."
      erb :signup
    end
  end

  get '/home' do
    logged_in?
    @quotes = quotes
    @movies = current_user.movies
    erb :homepage
  end

  post '/home' do
    logged_in?
    @quotes = quotes
    @movie = Movie.find_by_id(params[:movie_id])
    @movie.review = params[:review].gsub("\r\n\r", "<br>").gsub("\r\n", "<br>").gsub("\n", "<br>")
    @movie.user_id = session[:user_id]
    current_user.movies << @movie
    @movies = current_user.movies
    erb :homepage
  end

end
