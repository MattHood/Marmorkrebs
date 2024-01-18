class AddTypeToVotes < ActiveRecord::Migration[7.1]
  def change
    add_column :votes, :type, :integer, null: false
  end
end
