class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :content
      t.integer :project_id
      t.integer :priority
      t.datetime :deadline
      t.boolean :done, default: false

      t.timestamps
    end
    add_index :tasks, [:project_id, :priority]
  end
end
