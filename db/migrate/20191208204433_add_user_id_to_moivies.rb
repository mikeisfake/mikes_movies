class AddUserIdToMoivies < ActiveRecord::Migration
  def change
    add_column :movies, :user_id, :bigint
  end
end
