class ICalService
  def initialize(cal_start:, cal_end:)
  end

  def icalendar
    Icalendar::Calendar.new
  end
end
