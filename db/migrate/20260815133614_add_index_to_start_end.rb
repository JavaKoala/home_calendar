class AddIndexToStartEnd < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    change_table :events, bulk: true do |t|
      t.index :start, algorithm: :inplace
      t.index :end, algorithm: :inplace
    end
  end
end
