class AddUrlAndDescriptionToBusinesses < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :URL, :string
    add_column :businesses, :description, :text
  end
end
