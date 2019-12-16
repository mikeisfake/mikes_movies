class RemoveWatchlistFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :watchlist, :string
  end
end
