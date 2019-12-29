# frozen_string_literal: true

class User < ActiveRecord::Base
  validates :password, :username, presence: true
  validates :username, uniqueness: { case_sensitive: false }

  has_secure_password
  has_many :movies
end
