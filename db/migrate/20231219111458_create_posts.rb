class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.text :link
      t.text :body
      t.references :submitter, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
