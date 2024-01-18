namespace :dev do
  desc 'Creates sample data for local development'
  task prime: :environment do
    puts "Populating dev database..."
    unless Rails.env.development?
      raise 'This task can only be run in the development environment'
    end

    require "factory_bot_rails"
    include FactoryBot::Syntax::Methods

    bitwarden = BitwardenExport.new

    50.times.each do
      user = create :user
      bitwarden.add_password user
      post = create :post, submitter: user
    end

    # Blocks below are yet to be tested

    def sample_without_replacement(arr, n = 1)
      sampled_elements = []
      while sampled_elements.length < n and not arr.empty?
        index = rand 0..(arr.length - 1)
        sampled_elements << arr.delete_at(index)
      end
      sampled_elements
    end

    def add_child_comments(comments, parent_comment)
      num_children = rand 0..5
      children = sample_without_replacement comments, num_children
      children.each do |child|
        return if comments.empty?
        child.update parent: parent_comment
        add_child_comments comments, child
      end
    end
    
    Post.all.each do |post|
      comments = 20.times.map { create(:comment, author: User.all.sample, post:) }
      add_child_comments comments, nil
      # Delete remaining comments
      comments.each &:destroy
    end
    
    password_export_filename = bitwarden.export
    puts "Done. User passwords exported to #{password_export_filename}"
  end
end

class BitwardenExport
  APP_NAME = "Marmorkrebs"
  def initialize
    @data = {
      'items': []
    }
  end
  
  def add_password(user)
    @data[:items] << {
      'id': user.id.to_s,
      'name': build_name(user),
      'fields': [
        'login': {
          'uris': [
            {
              'uri': 'marmorkrebs'
            },
          ],
          'username': user.email,
          'password': user.password
        } 
      ]
    }
  end

  def to_json
    @data.to_json
  end

  def export
    filename = "#{DateTime.now} #{Rails.env} Bitwarden Password Export.json"
    File.open(filename, mode = 'w') do |file|
      file.write to_json
    end
    filename
  end
  
  private
  def build_name(user)
    "#{APP_NAME} #{Rails.env} | #{user.username}"
  end
end
