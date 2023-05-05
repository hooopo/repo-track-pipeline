class CreateRepoFullNameConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :repo_full_name_configs do |t|
      t.string :full_name, index: {unique: true}
    end
  end
end
