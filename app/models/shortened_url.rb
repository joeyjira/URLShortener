require 'securerandom'

class ShortenedUrl < ApplicationRecord
  include
  validates :short_url, presence: true, uniqueness: true
  validates :long_url, presence: true, uniqueness: true
  validates :user_id, presence: true

  belongs_to :user,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  def self.random_code(long_url, email)
    short_url = SecureRandom.urlsafe_base64
    ShortenedUrl.new(long_url, short_url, User.new(email: email))
  end

  def initialize(long_url, short_url, user)
    @long_url = long_url
    @short_url = short_url
    @user = user
  end
end
