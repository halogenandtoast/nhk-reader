class AddDataToStories < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :data, :json, default: {}
  end
end
