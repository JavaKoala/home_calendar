require 'test_helper'

module Api
  module V1
    class SearchesControllerTest < ActionDispatch::IntegrationTest
      test 'should get index' do
        get api_v1_searches_url
        assert_response :success
      end

      test 'should return json' do
        get api_v1_searches_url
        assert_equal response.parsed_body, []
      end

      test 'should return searched events' do
        Event.create!(title: 'Test', start: 1.hour.ago, end: Time.current)

        get api_v1_searches_url, params: { search: 'MyString' }

        assert_equal response.parsed_body.count, 2
        assert_equal response.parsed_body.first['title'], 'MyString'
      end
    end
  end
end
