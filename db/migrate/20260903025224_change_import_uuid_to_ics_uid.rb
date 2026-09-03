class ChangeImportUuidToIcsUid < ActiveRecord::Migration[8.1]
  def change
    rename_column :events, :import_uuid, :ics_uid
  end
end
