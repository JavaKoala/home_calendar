class EventChangesForImport < ActiveRecord::Migration[8.1]
  def up
    change_table :events, bulk: true do |t|
      t.change :title, :text
      t.string :import_uuid
      t.index :import_uuid, unique: true
    end
  end

  def down
    change_table :events, bulk: true do |t|
      t.change :title, :string
      t.remove_index :import_uuid
      t.remove :import_uuid
    end
  end
end
