class CreateReadingLists < ActiveRecord::Migration[8.1]
  def change
    create_table :reading_lists do |t|
      t.string :user, null: false
      t.references :bibliography, null: false, foreign_key: true

      t.timestamps
    end

    add_index :reading_lists, [ :user, :bibliography_id ], unique: true
  end
end
