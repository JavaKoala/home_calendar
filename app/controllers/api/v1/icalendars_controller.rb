module Api
  module V1
    class IcalendarsController < ApplicationController
      protect_from_forgery with: :null_session

      def show
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

      def create
        ics_file = params[:file]

        if ics_file.respond_to?(:read) && ics_file.content_type == 'text/calendar'
          ImportICalService.new(ics_file.read).import

          render status: :created, plain: 'Imported calendar'
        else
          render status: :unsupported_media_type, plain: 'ics file is required'
        end
      end
    end
  end
end
