class EnsureNewsIdIsUnique < ActiveRecord::Migration[5.0]
  def change
    add_index :stories, :news_id, unique: true
  end
end
