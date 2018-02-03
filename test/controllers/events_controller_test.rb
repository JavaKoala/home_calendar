require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @event1 = events(:one)
  end

  test 'should create new event' do
    get root_path
    assert_difference 'Event.count', 1 do
      post events_path, params: { event: { title: 'test title', 
                                           start: '2018-01-03 07:00:00',
                                           end: '2018-01-03 09:00:00',
                                           color: 'green' } }
      assert_response :success
    end
  end

  test 'should not create new event where the end is before the start' do
    assert_no_difference 'Event.count' do
      post events_path, params: { event: { title: 'test title', 
                                           start: '2018-01-03 09:00:00',
                                           end: '2018-01-03 07:00:00',
                                           color: 'green' } }
      assert_response :success
    end
  end

  test 'should update event' do
    patch event_path(@event1), params: { event: { title: 'updated event',
                                                  start: '2018-01-17 19:00:00',
                                                  end: '2018-01-17 21:00:00',
                                                  color: 'red' } }
    assert_response :success
    @event1.reload
    assert_equal @event1.title, 'updated event'
    assert_equal @event1.start, '2018-01-17 19:00:00'
    assert_equal @event1.end, '2018-01-17 21:00:00'
    assert_equal @event1.color, 'red'
  end

  test 'should not update event where the end is before the start' do
    patch event_path(@event1), params: { event: { title: 'updated event',
                                                  start: '2018-01-17 21:00:00',
                                                  end: '2018-01-17 19:00:00',
                                                  color: 'red' } }
    assert_response :success
    @event1.reload
    assert_not_equal @event1.title, 'updated event'
    assert_not_equal @event1.start, '2018-01-17 21:00:00'
    assert_not_equal @event1.end,   '2018-01-17 19:00:00'
    assert_not_equal @event1.color, 'red'
  end
end
