class Post < ApplicationRecord
  include Votable
  belongs_to :submitter, class_name: :User

  # Lists the most relevant posts
  def self.hot(limit = 25)
    Post.all.limit limit
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

  def to_param = short_id

  private
  def self.sqids = Sqids.new(min_length: 6)
end
