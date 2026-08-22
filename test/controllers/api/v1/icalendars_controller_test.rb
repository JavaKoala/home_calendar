require 'test_helper'

module Api
  module V1
    class IcalendarsControllerTest < ActionDispatch::IntegrationTest
      test 'should get show' do
        get api_v1_icalendar_path, params: { start: Event.last.start, end: Event.last.end }

        assert_response :success
        assert_equal 'text/calendar', response.media_type
        assert_match(/attachment; filename="home_calendar\.ics"/, response.headers['Content-Disposition'])
        assert_includes response.body, 'VCALENDAR'
      end

      test 'should return bad request if start is not present' do
        get api_v1_icalendar_path, params: { end: Event.last.end }

        assert_response :bad_request
        assert_equal 'start and end parameters are required', response.body
      end

      test 'should return bad request if end is not present' do
        get api_v1_icalendar_path, params: { start: Event.last.start }

        assert_response :bad_request
        assert_equal response.body, 'start and end parameters are required'
      end

      test 'should import calendar' do
        ics_file = fixture_file_upload('home_calendar.ics', 'text/calendar')

        assert_difference 'Event.count' do
          post api_v1_icalendar_path, params: { file: ics_file }
        end

        assert_response :created
        assert_equal response.body, 'Imported calendar'
      end

      test 'should return unsupported media type for invalid file' do
        post api_v1_icalendar_path, params: { file: 'invalid' }

        assert_response :unsupported_media_type
        assert_equal response.body, 'ics file is required'
      end

      test 'should return unsupported media type for invalid media type' do
        ics_file = fixture_file_upload('home_calendar.ics', 'text/application')

        post api_v1_icalendar_path, params: { file: ics_file }

        assert_response :unsupported_media_type
        assert_equal response.body, 'ics file is required'
      end
    end
  end
end
