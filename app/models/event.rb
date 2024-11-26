class Event < ApplicationRecord
  attr_accessor :recurring_times, :recurring_schedule, :apply_to_series

  validates :start, :end, presence: true
  validate :end_before_start, :more_than_24_hours

  def end_before_start
    return if self.end.blank? || start.blank?

    errors.add(:end, "can't be before start") if self.end < start
  end

  def more_than_24_hours
    return unless recurring_times.present? && (self.end - start) / 1.hour > 24

    errors.add(:end, "can't be greater than 24 hours for recurring event")
  end
end
