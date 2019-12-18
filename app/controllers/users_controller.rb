require "pry"

class UsersController < ApplicationController

  include Quotable

  get '/home' do
    if logged_in?
      @quotes = quotes
      @movies = current_user.movies
      erb :homepage
    else
      redirect '/'
    end
  end

  post '/home' do
    if logged_in?
      @quotes = quotes 
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

  get '/all/search' do
    if logged_in?
      @title = params[:search]
      allmovies = Movie.where("title LIKE ?", "%#{@title}%")
      @movies = allmovies.map do |movie|
        movie if movie.user_id == current_user.id
      end.compact
      erb :'all-search'
    end
  end


end
