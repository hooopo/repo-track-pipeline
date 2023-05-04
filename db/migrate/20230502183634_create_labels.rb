class CreateLabels < ActiveRecord::Migration[7.0]
  def change
    create_table :labels, id: false do |t|
      t.string :name
      t.bigint :item_id # issue_id or pull_request_id
      t.string :item_type # Issue or PullRequest
      t.bigint :repo_id
      t.index [:item_id, :item_type, :name], unique: true
    end
  end
end
