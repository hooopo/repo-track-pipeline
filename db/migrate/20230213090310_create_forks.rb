class CreateForks < ActiveRecord::Migration[7.0]
  def change
    create_table :forks, id: false do |t|
      t.bigint :id, primary_key: true
      t.bigint :parent
      
      t.string :author
      t.bigint :user_id
      t.string :name
      t.timestamps

      t.index :parent
      t.index :created_at 
      t.index :updated_at
      t.index :author
    end
  end
end
