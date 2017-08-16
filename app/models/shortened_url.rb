# == Schema Information
#
# Table name: shortened_urls
#
#  id           :integer          not null, primary key
#  long_url     :string           not null
#  short_url    :string           not null
#  submitter_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ShortenedUrl < ApplicationRecord

  validates :short_url, uniqueness: true, presence: true
  validates :long_url, :submitter_id, presence: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :submitter_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: :Visit

  has_many :visitors,
    through: :visits,
    source: :user

    has_many :distinct_users,
      -> { distinct },
      through: :visits,
      source: :user

  def self.random_code
    code = SecureRandom::urlsafe_base64
    while ShortenedUrl.exists?(short_url: code)
      code = SecureRandom::urlsafe_base64
    end
    code
  end

  def self.generate(user, long_url)
    ShortenedUrl.create!({
      long_url: long_url,
      short_url: self.random_code,
      submitter_id: user.id
      })
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    self.distinct_users.count
  end

  def num_recent_uniques(minutes)
    self.distinct_users.where('created_at >= ?', minutes.minutes.ago).count
  end

end
