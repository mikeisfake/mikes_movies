require "pry"

class UsersController < ApplicationController

  get '/home' do
    if logged_in?
      @movies = current_user.movies
      erb :homepage
    else
      redirect '/'
    end
  end

  post '/home' do
    if logged_in?
      @movie = Movie.find_by_id(params[:movie_id])
      @movie.review = params[:review].gsub("\r\n\r", "<br>").gsub("\r\n", "<br>").gsub("\n", "<br>")
      @movie.user_id = session[:user_id]
      current_user.movies << @movie
      @movies = current_user.movies
      erb :homepage
    else
      redirect '/'
    end
  end

  get '/all' do
    if logged_in?
      @movies = current_user.movies
      erb :all
    end
  end


end
