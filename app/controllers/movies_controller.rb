require 'HTTParty'
require 'pry'

class MoviesController < ApplicationController

  get '/movies/search' do
    if logged_in?
      movie = params[:search]
      @movie_list = []
      if movie
        query = HTTParty.get('http://www.omdbapi.com/?s='+movie+'&apikey=2cedcff3&')
        if query['Error'] == nil
          @movie_list = query['Search'].compact
        end
      end
        erb :search
      else
      redirect '/'
    end
  end

  post '/movies/show' do
    if logged_in?
      if !params.empty?
        movie_id = params.keys[0]
        movie_hash = HTTParty.get('http://www.omdbapi.com/?i='+movie_id+'&apikey=2cedcff3&').compact
        title = movie_hash['Title']
        release_date = movie_hash['Year']
        director = movie_hash['Director']
        summary = movie_hash['Plot']
        poster = movie_hash['Poster']
        @movie = Movie.create(title: title, release_date: release_date, director: director, summary: summary, poster: poster)
        erb :show
      else
        redirect '/movies/search'
      end
    else
      redirect '/'
    end
  end

  get '/movies/:id' do
    if logged_in?
      @movie = Movie.find(params[:id])
      erb :display
    else
      redirect '/'
    end
  end

  get '/movies/:id/edit' do
    if logged_in?
      @movie = Movie.find(params[:id])
      erb :edit
    else
      redirect '/'
    end
  end

  patch '/movies/:id' do
    @movie = Movie.find(params[:id])

    if current_user.id == @movie.user_id
      @movie.review = (params[:review])
      @movie.save

      redirect '/home'
    else
      redirect '/'
    end
  end

  delete '/movies/:id' do
    Movie.destroy(params[:id])
    redirect('/home')
  end


end
