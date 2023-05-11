class CreateClones < ActiveRecord::Migration[7.0]
  def change
    create_table :clones, id: false do |t|

      t.datetime :timestamp
      t.bigint :repo_id 
      t.integer :count 
      t.integer :uniques

      t.index [:repo_id, :timestamp], unique: true
    end
  end
end
