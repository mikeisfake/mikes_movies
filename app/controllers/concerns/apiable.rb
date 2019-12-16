module APIable

  def search_api(string)
    HTTParty.get('http://www.omdbapi.com/?s='+string+'&apikey=2cedcff3&')
  end

  def return_api(string)
    HTTParty.get('http://www.omdbapi.com/?i='+string+'&apikey=2cedcff3&').compact
  end

end
