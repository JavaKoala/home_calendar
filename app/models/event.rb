class Event < ApplicationRecord
  validate :end_before_start

  def all_day_event?
    self.start == self.start.midnight && self.end == self.end.midnight ? true : false
  end

  def end_before_start
    errors.add(:start, "End can't be before start") if self.end < self.start
  end
end
