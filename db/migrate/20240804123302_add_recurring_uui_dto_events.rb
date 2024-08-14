class AddRecurringUuiDtoEvents < ActiveRecord::Migration[7.1]
  def change
    change_table :events, bulk: true do |t|
      t.string :recurring_uuid, index: true
    end
  end
end
