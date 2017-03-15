class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :events, dependent: :destroy
  has_one :profile
  has_many :registrations, dependent: :destroy
  has_many :registered_events, through: :registrations, source: :event

  def has_profile?
    profile.present? && !profile.id.nil?
  end

  def full_name
    profile.full_name
  end
end
