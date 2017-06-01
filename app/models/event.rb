class Event < ApplicationRecord
  belongs_to :user
  has_many :photos, dependent: :destroy
  has_and_belongs_to_many :categories
  has_many :registrations, dependent: :destroy
  has_many :guests, through: :registrations, source: :user

  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 500 }

  scope :published, ->{ where(active: true) }

  def bargain?
    price < 30
  end

  def self.on_date(date)
    where("? BETWEEN starts_at AND ends_at", date)
  end

  def self.starts_on(date)
    where("starts_at BETWEEN ? AND ?", date.beginning_of_day, date.end_of_day)
  end

  def self.order_by_price
    order(:price)
  end

  def self.by_name
    order(:name)
  end
end
