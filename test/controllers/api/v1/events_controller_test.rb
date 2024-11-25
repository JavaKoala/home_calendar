require 'test_helper'

module Api
  module V1
    class EventsControllerTest < ActionDispatch::IntegrationTest
      test 'should get index' do
        get api_v1_event_url(Event.first.id)
        assert_response :success
      end

      test 'should return event' do
        get api_v1_event_url(Event.first.id)
        assert_equal Event.first.id, JSON.parse(@response.body)['id']
        assert_equal Event.first.title, JSON.parse(@response.body)['title']
        assert_equal Event.first.start, JSON.parse(@response.body)['start']
        assert_equal Event.first.end, JSON.parse(@response.body)['end']
        assert_equal Event.first.color, JSON.parse(@response.body)['color']
      end

      test 'should empty json for nonexistant event' do
        get api_v1_event_url(Event.last.id + 1)
        assert_response :not_found
        assert_equal '{}', @response.body
      end
    end
  end
end
