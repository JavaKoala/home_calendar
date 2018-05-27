class Utf8mb4 < ActiveRecord::Migration[5.1]
  def change
    execute "ALTER TABLE events CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
  end
end
