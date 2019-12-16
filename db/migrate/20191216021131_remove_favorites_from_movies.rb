class RemoveFavoritesFromMovies < ActiveRecord::Migration
  def change
    remove_column :movies, :favorites, :integer
  end
end
