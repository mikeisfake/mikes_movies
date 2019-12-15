class User <ActiveRecord::Base
  validates :username, uniqueness: { case_sensitive: false}
  validates :password, presence: true

  has_secure_password
  has_many :movies
end
