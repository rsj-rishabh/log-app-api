class CreateLogData < ActiveRecord::Migration[7.0]
  def change
    create_table :log_data do |t|
      t.integer :log_index
      t.jsonb :log_info

      t.timestamps
    end
  end
end
