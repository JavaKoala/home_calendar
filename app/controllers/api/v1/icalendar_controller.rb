module Api
  module V1
    class IcalendarController < ApplicationController
      def index
        if params[:start].present? && params[:end].present?
          service = ExportICalService.new(event_start: params[:start], event_end: params[:end])

          send_data service.to_ical,
                    filename: 'home_calendar.ics',
                    type: 'text/calendar',
                    disposition: 'attachment'
        else
          render status: :bad_request, plain: 'start and end parameters are required'
        end
      end
    end
  end
end
