class TagTopic < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :taggings,
    primary_key: :id,
    foreign_key: :tag_topic_id,
    class_name: :Tagging

  has_many :tagged_urls,
    through: :taggings,
    source: :url

  def popular_links
    all_sorted = self.tagged_urls.sort_by { |url| -url.num_clicks }

    all_sorted[0..4].each do |url|
      puts "#{url.long_url} has #{url.num_clicks} visits"
    end
  end

end
