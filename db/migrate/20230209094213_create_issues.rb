class CreateIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :issues, id: false do |t|
      t.bigint :id, primary_key: true
      t.bigint :repo_id
      t.boolean :locked
      t.string :title
      t.boolean :closed
      t.datetime :closed_at

      t.string :state
      t.integer :number
      t.string :author
      t.bigint :user_id, index: true
      t.string :author_association
      t.timestamps
      t.index :updated_at 
      t.index :created_at 
      t.index :author
    end
  end
end