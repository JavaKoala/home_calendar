require 'test_helper'

module Api
  module V1
    class EventsControllerTest < ActionDispatch::IntegrationTest
      test 'should get index' do
        get api_v1_events_url, params: { start: Event.last.start, end: Event.last.end }
        assert_response :success
        assert_equal response.parsed_body.last['id'], Event.last.id
      end

      test 'should return bad request if start is not present' do
        get api_v1_events_url, params: { end: Event.last.end }
        assert_response :bad_request
        assert_equal response.body, 'start and end parameters are required'
      end

      test 'should return bad request if end is not present' do
        get api_v1_events_url, params: { start: Event.last.start }
        assert_response :bad_request
        assert_equal response.body, 'start and end parameters are required'
      end

      test 'should get event' do
        get api_v1_event_url(Event.first.id)
        assert_response :success
      end

      test 'should return event' do
        get api_v1_event_url(Event.first.id)
        assert_equal Event.first.id, response.parsed_body['id']
        assert_equal Event.first.title, response.parsed_body['title']
        assert_equal Event.first.start, response.parsed_body['start']
        assert_equal Event.first.end, response.parsed_body['end']
        assert_equal Event.first.color, response.parsed_body['color']
      end

      test 'should empty json for nonexistant event' do
        get api_v1_event_url(Event.last.id + 1)
        assert_response :not_found
        assert_equal '{}', response.body
      end
    end
  end
end