class AddFullTextIndexToEvents < ActiveRecord::Migration[8.1]
  def change
    add_index :events, :title, type: :fulltext
  end
end
