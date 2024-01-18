class ChangeVotesColumn < ActiveRecord::Migration[7.1]
  def change
    rename_column :votes, :type, :kind
  end
end
