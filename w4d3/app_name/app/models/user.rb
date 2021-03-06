# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "bcrypt"

class User < ApplicationRecord
  # before_validation :ensure_session_token
  # validates :username, :session_token, presence: true, uniqueness: true
  # validates :password, presence: true, message: "Password can't be blank"
  # validates :password, length: {minimum: 6, allow_nil: true}

  # def self.find_by_credentials
  #   User
  #     .where("username = ?", self.username)
  #     .where("password = ?", self.password)
  # end

  # def self.generate_session_token
  # end

  # def reset_session_token!
  # end

  # def ensure_session_token!
  # end

  # def password=
  # end

  #^^^how far I got in 30

  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: {message: 'Password can\'t be blank'}
  validates :session_token, presence: true, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}
  before_validation :ensure_session_token

  attr_reader :password

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return user if user && BCrypt::Password.new(user.password_digest).is_password?(password)
    nil
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
end
