class AddFavoritesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :favorites, :string
  end
end
