require 'test_helper'

module Api
  module V1
    class SearchesControllerTest < ActionDispatch::IntegrationTest
      test 'should get index' do
        get api_v1_searches_url
        assert_response :success
      end
    end
  end
end
