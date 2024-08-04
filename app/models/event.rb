class Event < ApplicationRecord
  attr_accessor :recurring_days

  validate :end_before_start, :more_than_24_hours

  def end_before_start
    errors.add(:end, "can't be before start") if self.end < start
  end

  def more_than_24_hours
    return unless recurring_days.present? && (self.end - start) / 1.hour > 24

    errors.add(:end, "can't be greater than 24 hours for recurring event")
  end
end
