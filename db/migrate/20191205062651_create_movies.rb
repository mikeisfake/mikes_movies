class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.string :release_date
      t.string :director
      t.string :summary
      t.integer :rating
      t.string :review
    end 
  end
end
