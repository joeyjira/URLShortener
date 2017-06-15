# == Schema Information
#
# Table name: shortened_urls
#
#  id         :integer          not null, primary key
#  long_url   :string           not null
#  short_url  :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'securerandom'

class ShortenedUrl < ApplicationRecord
  validates :short_url, presence: true, uniqueness: true
  validates :long_url, presence: true, uniqueness: true
  validates :user_id, presence: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  def self.random_code
    unique_code = SecureRandom.urlsafe_base64

    until exists?(unique_code)
      unique_code = SecureRandom.urlsafe_base64
    end

    unique_code
  end

  def self.generate_short_url(long_url, submitter)
    ShortenedUrl.create(long_url: long_url, short_url: ShortenedUrl.random_code,
      user_id: submitter.id)
  end

  def num_clicks
    count = 0

    Visit.all.each { |row| count += 1 if self.id == row.short_url_id }

    count
  end

  def num_uniques
  end

  def num_recent_uniques
  end
end
