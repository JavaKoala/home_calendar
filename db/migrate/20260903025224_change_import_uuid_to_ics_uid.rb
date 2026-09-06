class ChangeImportUuidToIcsUid < ActiveRecord::Migration[8.1]
  def change
    rename_column :events, :import_uuid, :ics_uid
    change_column_default :events, :ics_uid, from: nil, to: -> { '(UUID())' }
  end
end
