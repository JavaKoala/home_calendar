var initialize_calendar;
var eventStart;
var eventEnd;
initialize_calendar = function() {
  $('.calendar').each(function(){
    var calendar = $(this);
    calendar.fullCalendar({
      header: {
        left: 'prev,next today',
        center: 'title',
        right: 'month,agendaWeek,agendaDay'
      },
      selectable: true,
      selectHelper: true,
      editable: true,
      eventLimit: true,
      defaultView: 'agendaWeek',
      allDaySlot: false,
      minTime: "08:00:00",
      maxTime: "23:00:00",
      nowIndicator: true,
      contentHeight: 'auto',
      events: '/events.json',
      select: function(start, end) {
        eventStart = moment(start).format('YYYY-MM-DD').concat('T').concat(moment(start).format('HH:mm'));
        eventEnd = moment(end).format('YYYY-MM-DD').concat('T').concat(moment(end).format('HH:mm'));
        $.getScript('/events/new', function() {
        });
        calendar.fullCalendar('unselect');
      },

      eventDrop: function(event, delta, revertFunc) {
        event_data = {
          event: {
            id: event.id,
            start: event.start.format(),
            end: event.end.format()
          }
        };
        $.ajax({
            url: event.update_url,
            data: event_data,
            type: 'PATCH'
        });
      },

      eventClick: function(event, jsEvent, view) {
        $.getScript(event.edit_url, function() {
        });
      }
    });
  })
};
$(document).on('turbolinks:load', initialize_calendar);