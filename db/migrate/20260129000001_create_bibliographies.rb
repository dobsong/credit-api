class CreateBibliographies < ActiveRecord::Migration[8.1]
  def change
    create_table :bibliographies do |t|
      t.string :citation, null: false
      t.string :title, null: false
      t.string :authors
      t.integer :year
      t.string :url, null: false

      t.timestamps
    end

    add_index :bibliographies, :citation, unique: true
  end
end
