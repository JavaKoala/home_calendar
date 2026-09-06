class ChangeIcsUidNotNull < ActiveRecord::Migration[8.1]
  def change
    change_column_null :events, :ics_uid, false
  end
end
