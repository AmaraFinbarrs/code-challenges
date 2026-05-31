class Challenge < ApplicationRecord
  validate :title, presence: true
  validate :description, presence: true
  validate :start_date, presence: true
  validate :end_date, presence: true
end
