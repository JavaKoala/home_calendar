require 'test_helper'

module Api
  module V1
    class IcalendarControllerTest < ActionDispatch::IntegrationTest
      test 'should get index' do
        get api_v1_icalendar_index_path, params: { start: Event.last.start, end: Event.last.end }

        assert_response :success
        assert_equal 'text/calendar', response.media_type
        assert_match(/attachment; filename="home_calendar\.ics"/, response.headers['Content-Disposition'])
        assert_includes response.body, 'VCALENDAR'
      end

      test 'should return bad request if start is not present' do
        get api_v1_icalendar_index_path, params: { end: Event.last.end }

        assert_response :bad_request
        assert_equal response.body, 'start and end parameters are required'
      end

      test 'should return bad request if end is not present' do
        get api_v1_icalendar_index_path, params: { start: Event.last.start }

        assert_response :bad_request
        assert_equal response.body, 'start and end parameters are required'
      end
    end
  end
end
