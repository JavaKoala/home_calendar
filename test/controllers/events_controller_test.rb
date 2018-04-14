require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @event1 = events(:one)
  end

  def create_event(start_time, end_time, event_color)
    first('td', class: 'fc-widget-content').click
    fill_in('event_title', with: 'test title')
    fill_in('event_start', with: Date.today.strftime("%m/%d/%Y") + "\t" + start_time)
    fill_in('event_end', with: Date.today.strftime("%m/%d/%Y") + "\t" + end_time)
    select(event_color, from: 'event_color')
    click_button('Create Event')
  end

  test 'should create new event' do
    visit('/')
    assert_difference 'Event.count', 1 do
      create_event("09:00AM", "02:00PM", 'Green')
      assert has_content?('test title')
    end
  end

  test 'should not create new event where the end is before the start' do
    visit('/')
    assert_no_difference 'Event.count' do
      create_event("11:00AM", "09:00AM", 'Green')
      assert !has_content?('test title')
      assert has_content?("End can't be before start")
    end
  end

  test 'should redirect to root_url for new event where the end is before the start' do
    assert_no_difference 'Event.count' do
      post events_path, params: { event: { title: 'test title', 
                                           start: '2018-01-03 09:00:00',
                                           end: '2018-01-03 07:00:00',
                                           color: 'green' } }
      assert_redirected_to root_url
      assert_not flash.empty?
    end
  end

  test 'should update event' do
    visit('/')
    create_event("09:00AM", "02:00PM", 'Green')
    find('div', class: 'fc-title', text: 'test title').click
    fill_in('event_title', with: 'updated event')
    fill_in('event_start', with: Date.today.strftime("%m/%d/%Y") + "\t03:30PM")
    fill_in('event_end', with: Date.today.strftime("%m/%d/%Y") + "\t07:30PM")
    select('Midnight Blue', from: 'event_color')
    click_button('Update Event')
    assert has_content?('updated event')
    assert has_content?('3:30 - 7:30')
    @updated_event = Event.find_by(title: 'updated event')
    assert_equal @updated_event.color, 'midnightblue'
  end

  test 'should not update event where the end is before the start' do
    visit('/')
    create_event("09:00AM", "02:00PM", 'Green')
    find('div', class: 'fc-title', text: 'test title').click
    fill_in('event_title', with: 'updated event')
    fill_in('event_start', with: Date.today.strftime("%m/%d/%Y") + "\t07:30PM")
    fill_in('event_end', with: Date.today.strftime("%m/%d/%Y") + "\t03:30PM")
    click_button('Update Event')
    assert_not has_content?('updated event')
    assert has_content?("End can't be before start")
  end

  test 'should redirect to root_url for updated event where the end is before the start' do
    patch event_path(@event1), params: { event: { title: 'updated event',
                                                  start: '2018-01-17 21:00:00',
                                                  end: '2018-01-17 19:00:00',
                                                  color: 'red' } }
    assert_redirected_to root_url
    assert_not flash.empty?
    @event1.reload
    assert_not_equal @event1.title, 'updated event'
    assert_not_equal @event1.start, '2018-01-17 21:00:00'
    assert_not_equal @event1.end,   '2018-01-17 19:00:00'
    assert_not_equal @event1.color, 'red'
  end

  test 'should delete event' do
    visit('/')
    create_event("09:00AM", "02:00PM", 'Green')
    find('div', class: 'fc-title', text: 'test title').click
    assert_difference 'Event.count', -1 do
      accept_confirm do
        click_link('Delete')
      end
      assert_not has_content?('test title')
    end
  end
end
