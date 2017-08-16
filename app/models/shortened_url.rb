class ShortenedUrl < ApplicationRecord

  validates :short_url, uniqueness: true, presence: true
  validates :long_url, :submitter_id, presence: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :submitter_id,
    class_name: :User
    
end
