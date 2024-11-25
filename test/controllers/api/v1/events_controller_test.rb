require 'test_helper'

module Api
  module V1
    class EventsControllerTest < ActionDispatch::IntegrationTest
      test 'should get index' do
        get api_v1_event_url(Event.first.id)
        assert_response :success
      end
    end
  end
end
