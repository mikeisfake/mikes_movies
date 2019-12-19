require 'HTTParty'
require 'byebug'

class MoviesController < ApplicationController

  include APIable

  get '/movies' do
    logged_in?
    @movies = current_user.movies
    erb :movies
  end

  get '/movies/search' do
    logged_in?
    @movie = params[:search]
    @movie_list = []
    if @movie
      query = search_api(@movie)
      if query['Error'] == nil
        @movie_list = query['Search'].compact
      else
        flash.now[:message] = "just what do you think you're doing, dave?"
        erb :search
      end
    end
      erb :search
  end

  post '/movies/create' do
    logged_in?
    if !params.empty?
      movie_id = params[:imdbID].keys[0]
      movie_hash = return_api(movie_id)
      title = movie_hash['Title']
      release_date = movie_hash['Year']
      if movie_hash['Director'] == "N/A"
        director = movie_hash['Writer']
      else
        director = movie_hash['Director']
      end
      summary = movie_hash['Plot']
      poster = movie_hash['Poster']

      @movie = Movie.create(title: title, release_date: release_date, director: director, summary: summary, poster: poster)
      erb :create
    else
      redirect '/home'
    end
  end

  get '/movies/:id' do
    logged_in?
    @movie = Movie.find(params[:id])
    owns_movie?
    erb :display
  end

  get '/movies/:id/edit' do
    logged_in?
    @movie = Movie.find(params[:id])
    owns_movie?
    @movie.review.gsub!("<br>", "&#13;&#10")
    erb :edit
  end

  patch '/movies/:id' do
    @movie = Movie.find(params[:id])
    owns_movie?
    @movie.update(review: params[:review].gsub("\r\n\r", "<br>").gsub("\r\n", "<br>").gsub("\n", "<br>"))
    redirect '/home'
  end

  delete '/movies/:id' do
    @movie = Movie.find_by_id(params[:id])
    owns_movie?
    @movie.destroy
    redirect '/home'
  end

  get '/reviews/search' do
    logged_in?
    @title = params[:search]
    allmovies = Movie.where("title LIKE ?", "%#{@title}%")
    @movies = allmovies.map do |movie|
      movie if movie.user_id == current_user.id
    end.compact
    if @movies.empty?
      flash.now[:message] = "look dave, i can see you're really upset about this."
    end
    erb :'reviews-search'
  end

end
