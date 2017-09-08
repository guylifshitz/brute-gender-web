class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :note
      t.text :type
      t.timestamps null: false
    end
  end
end
