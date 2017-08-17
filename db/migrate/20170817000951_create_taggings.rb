class CreateTaggings < ActiveRecord::Migration[5.1]
  def change
    create_table :taggings do |t|
      t.integer :tag_topic_id, null: false
      t.integer :url_id, null: false
      t.timestamps
    end
    add_index :taggings, [:tag_topic_id, :url_id]
  end
end
