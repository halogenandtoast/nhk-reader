class CreateStories < ActiveRecord::Migration[5.0]
  def change
    create_table :stories do |t|
      t.string :title
      t.string :title_with_ruby
      t.string :news_id
      t.datetime :published_at
      t.string :url
      t.text :body
      t.boolean :fetched

      t.timestamps
    end
  end
end
