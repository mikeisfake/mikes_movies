# frozen_string_literal: true

require 'pry'

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
      flash[:success] = "welcome to your homepage #{current_user.username}. try searching for a movie to review"
      redirect '/home'
    else
      flash.now[:alert] = "i'm sorry dave. i'm afraid i can't do that."
      erb :signup
    end
  end

  delete '/user/delete' do
    logged_in?
    @user = current_user
    @user.destroy
    session.clear
    flash[:alert] = "goodbye forever"
    redirect '/'
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
    @movie.review = params[:review].gsub("\r\n\r", '<br>').gsub("\r\n", '<br>').gsub("\n", '<br>')
    @movie.user_id = session[:user_id]
    current_user.movies << @movie
    @movies = current_user.movies
    flash.now[:success] = "ohh look a new review!"
    erb :homepage
  end
end
