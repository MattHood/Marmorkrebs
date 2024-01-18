class Comment < ApplicationRecord
  include Votable
  belongs_to :author, class_name: :User
  belongs_to :post
  belongs_to :parent, class_name: :Comment, optional: true
  has_many :comments, foreign_key: :parent_id
end
