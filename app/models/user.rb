class User <ActiveRecord::Base
  validates :username, uniqueness: { case_sensitive: false}
  
  has_secure_password
  has_many :movies
end
