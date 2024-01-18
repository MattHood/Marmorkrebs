class Post < ApplicationRecord
  include Votable
  belongs_to :submitter, class_name: :User
  has_many :comments

  # Lists the most relevant posts
  def self.hot(page = 1, limit = 25)
    Post.all.offset(limit * (page - 1)).limit(limit)
  end

  # Finds a record by its public identifier
  def self.find_by_short_id(short_id)
    decoded_id = sqids.decode(short_id)
    Post.find_by(id: decoded_id)
  end

  # The public identifier for a post
  def short_id
    Post.sqids.encode [id]
  end

  private
  def self.sqids = Sqids.new(min_length: 6)
end
