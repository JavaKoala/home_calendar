require 'test_helper'

class RecurringTest < ActionDispatch::IntegrationTest
  def setup
    @event1 = events(:one)
  end

  def create_events(start_time, end_time, event_color, recurring_days)
    first('td', class: 'fc-widget-content').click
    fill_in('event_title', with: 'test title')
    fill_in('event_start', with: "#{Time.zone.today.strftime('%m/%d/%Y')}\t#{start_time}")
    fill_in('event_end', with: "#{Time.zone.today.strftime('%m/%d/%Y')}\t#{end_time}")
    select(event_color, from: 'event_color')
    click_on('Recurring')
    fill_in('event_recurring_days', with: recurring_days.to_s)
    click_on('Create Event')
    sleep 0.3
  end

  test 'should create multiple events' do
    visit('/')
    assert_difference 'Event.count', 3 do
      create_events('09:00AM', '02:00PM', 'Green', 2)
      assert_text('test title', count: 3)
    end
  end

  test 'delete multiple events' do
    visit('/')
    create_events('09:00AM', '02:00PM', 'Green', 2)
    first('div', class: 'fc-title', text: 'test title').click

    assert_difference 'Event.count', -3 do
      accept_confirm do
        find_by_id('event_apply_to_series').click
        click_on('Delete')
      end
      sleep 0.3
    end

    assert_not has_content?('test title')
  end

  test 'delete single event in events' do
    visit('/')
    create_events('09:00AM', '02:00PM', 'Green', 2)
    first('div', class: 'fc-title', text: 'test title').click

    assert_difference 'Event.count', -1 do
      accept_confirm do
        click_on('Delete')
      end
      sleep 0.3
    end

    assert_text('test title', count: 2)
  end
end
