class BackfillIcsUid < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL.squish
      UPDATE home_calendar_development.events
      SET ics_uid = UUID()
      WHERE ics_uid IS NULL;
    SQL
  end

  def down
    # Do not need to backfill on rollback
  end
end
