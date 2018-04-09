class CreateBusinesses < ActiveRecord::Migration[5.1]
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :industries
      t.string :employees
      t.string :other_partners
      t.string :other_competitors

      t.timestamps
    end
  end
end
