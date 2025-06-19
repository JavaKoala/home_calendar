require 'test_helper'

class RecurringTest < ActionDispatch::IntegrationTest
  def setup
    @event1 = events(:one)
  end

  def create_event_start(start_time)
    if Time.zone.now.sunday?
      "#{Time.zone.today.strftime('%m/%d/%Y')}\t#{start_time}"
    else
      "#{Time.zone.today.monday.strftime('%m/%d/%Y')}\t#{start_time}"
    end
  end

  def create_event_end(end_time)
    if Time.zone.now.sunday?
      "#{Time.zone.today.strftime('%m/%d/%Y')}\t#{end_time}"
    else
      "#{Time.zone.today.monday.strftime('%m/%d/%Y')}\t#{end_time}"
    end
  end

  def create_events(start_time, end_time, event_color, recurring_times, recurring = nil)
    first('td', class: 'fc-widget-content').click
    fill_in('event_title', with: 'test title')
    fill_in('event_start', with: create_event_start(start_time))
    fill_in('event_end', with: create_event_end(end_time))
    select(event_color, from: 'event_color')
    click_on('Recurring')
    fill_in('event_recurring_times', with: recurring_times.to_s)
    choose(recurring) if recurring
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

  test 'should create weekly events' do
    visit('/')
    assert_difference 'Event.count', 3 do
      create_events('09:00AM', '02:00PM', 'Green', 2, 'weekly')
      assert_text('test title', count: 1)
    end

    if Time.zone.now.sunday?
      assert_equal (Time.zone.now.beginning_of_day + 2.weeks + 14.hours), Event.order(end: :desc).first.end
    else
      assert_equal (Time.zone.now.beginning_of_week + 2.weeks + 14.hours), Event.order(end: :desc).first.end
    end
  end

  test 'should create monthly events' do
    visit('/')
    assert_difference 'Event.count', 3 do
      create_events('09:00AM', '02:00PM', 'Green', 2, 'monthly')
      assert_text('test title', count: 1)
    end

    if Time.zone.now.sunday?
      assert_equal (Time.zone.now.beginning_of_day + 2.months + 14.hours), Event.order(end: :desc).first.end
    else
      assert_equal (Time.zone.now.beginning_of_week + 2.months + 14.hours), Event.order(end: :desc).first.end
    end
  end

  test 'should create bi-weekly events' do
    visit('/')
    assert_difference 'Event.count', 3 do
      create_events('09:00AM', '02:00PM', 'Green', 2, 'every 2 weeks')
      assert_text('test title', count: 1)
    end

    if Time.zone.now.sunday?
      assert_equal (Time.zone.now.beginning_of_day + 4.weeks + 14.hours), Event.order(end: :desc).first.end
    else
      assert_equal (Time.zone.now.beginning_of_week + 4.weeks + 14.hours), Event.order(end: :desc).first.end
    end
  end

  test 'should create every other day events' do
    visit('/')
    assert_difference 'Event.count', 3 do
      create_events('09:00AM', '02:00PM', 'Green', 2, 'every other day')
      assert_text('test title', count: 3)
    end

    if Time.zone.now.sunday?
      assert_equal (Time.zone.now.beginning_of_day - 4.days + 14.hours), Event.order(end: :desc).first.end
    else
      assert_equal (Time.zone.now.beginning_of_week + 4.days + 14.hours), Event.order(end: :desc).first.end
    end
  end

  test 'should update multiple events' do
    visit('/')
    create_events('09:00AM', '02:00PM', 'Green', 2)
    first('div', class: 'fc-title', text: 'test title').click
    fill_in('event_title', with: 'updated title')
    select('Green', from: 'event_color')
    find_by_id('event_apply_to_series').click
    click_on('Update Event')

    assert_text('updated title', count: 3)
  end

  test 'should update single event' do
    visit('/')
    create_events('09:00AM', '02:00PM', 'Green', 2)
    first('div', class: 'fc-title', text: 'test title').click
    fill_in('event_title', with: 'updated title')
    select('Green', from: 'event_color')
    click_on('Update Event')

    assert_text('updated title', count: 1)
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
