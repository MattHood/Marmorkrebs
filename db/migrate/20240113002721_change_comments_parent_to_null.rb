class ChangeCommentsParentToNull < ActiveRecord::Migration[7.1]
  def change
    change_column_null :comments, :parent_id, true
  end
end
