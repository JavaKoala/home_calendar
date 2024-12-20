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

      test 'should create event' do
        assert_difference 'Event.count', 1 do
          post api_v1_events_url, params: {
            event: {
              title: 'test title',
              start: Time.zone.now,
              end: 1.hour.from_now,
              color: 'Green'
            }
          }
        end

        assert_response :created
        assert_equal 'test title', response.parsed_body.first['title']
        assert_equal 'Green', response.parsed_body.first['color']
      end

      test 'should not create event if it does not pass validation' do
        assert_no_difference 'Event.count' do
          post api_v1_events_url, params: {
            event: {
              title: 'test title',
              start: 1.hour.from_now,
              end: Time.zone.now,
              color: 'Green'
            }
          }
        end

        assert_response :bad_request
        assert_equal "End can't be before start", response.parsed_body.first
      end

      test 'should update event' do
        event = Event.first
        patch api_v1_event_url(event.id), params: {
          event: {
            title: 'updated title',
            start: event.start,
            end: event.end,
            color: 'Green'
          }
        }

        assert_response :success
        assert_equal 'updated title', response.parsed_body.first['title']
        assert_equal 'Green', response.parsed_body.first['color']
      end

      test 'should not update invalid event' do
        event = Event.first
        patch api_v1_event_url(event.id), params: {
          event: {
            title: 'updated title',
            start: event.start,
            end: event.start - 1.hour,
            color: 'Green'
          }
        }

        assert_response :bad_request
        assert_equal "End can't be before start", response.parsed_body.first
      end

      test 'should return not found for nonexistant event' do
        patch api_v1_event_url(Event.last.id + 1), params: {
          event: {
            title: 'updated title',
            start: Time.zone.now,
            end: 1.hour.from_now,
            color: 'Green'
          }
        }

        assert_response :not_found
        assert_equal '{}', response.body
      end

      test 'should delete event' do
        event = Event.first
        assert_difference 'Event.count', -1 do
          delete api_v1_event_url(event.id)
        end
        assert_response :success
      end

      test 'should return not found when deleting nonexistant event' do
        delete api_v1_event_url(Event.last.id + 1)
        assert_response :not_found
        assert_equal '{}', response.body
      end
    end
  end
end
