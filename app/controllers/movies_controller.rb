require 'HTTParty'
require 'byebug'

class MoviesController < ApplicationController

  include APIable

  get '/movies/search' do
    if logged_in?
      @movie = params[:search]
      @movie_list = []
      if @movie
        query = search_api(@movie)
        if query['Error'] == nil
          @movie_list = query['Search'].compact
        else
          flash.now[:message] = "didn't find anything. try searching for something else?"
          erb :search
        end
      end
        erb :search
      else
        redirect '/'
    end
  end

  post '/movies/create' do
    if logged_in?
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
    else
      redirect '/'
    end
  end

  get '/movies/:id' do
    if logged_in?
      @movie = Movie.find(params[:id])
        if  owns_movie?
          erb :display
        else
          redirect '/home'
        end
    else
      redirect '/'
    end
  end

  get '/movies/:id/edit' do
    if logged_in?
      @movie = Movie.find(params[:id])
      if  owns_movie?
        @movie.review.gsub!("<br>", "&#13;&#10")
        erb :edit
      else
        redirect '/home'
      end
    else
      redirect '/'
    end
  end

  patch '/movies/:id' do
    @movie = Movie.find(params[:id])
    if owns_movie?
      @movie.update(review: params[:review].gsub("\r\n\r", "<br>").gsub("\r\n", "<br>").gsub("\n", "<br>"))
      redirect '/home'
    else
      redirect '/'
    end
  end

  delete '/movies/:id' do
    @movie = Movie.find_by_id(params[:id])
    if owns_movie?
      @movie.destroy
      redirect '/home'
    else
      redirect '/home'
    end
  end

end
