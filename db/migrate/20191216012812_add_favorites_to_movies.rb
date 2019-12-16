class AddFavoritesToMovies < ActiveRecord::Migration
   def change
     add_column :movies, :favorites, :integer
   end
 end
