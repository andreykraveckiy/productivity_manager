class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :content
      t.string :attachment
      t.integer :task_id

      t.timestamps
    end
    add_index :comments, [:task_id, :created_at]
  end
end
