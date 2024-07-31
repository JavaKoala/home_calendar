class Event < ApplicationRecord
  attr_accessor :recurring_days

  validate :end_before_start

  def end_before_start
    errors.add(:end, "can't be before start") if self.end < start
  end
end
