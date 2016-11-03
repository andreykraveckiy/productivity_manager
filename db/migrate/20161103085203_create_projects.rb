class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
    add_index :projects, [:user_id, :created_at]
  end
end
