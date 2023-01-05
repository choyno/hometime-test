class CreateGuests < ActiveRecord::Migration[7.0]
  def change
    create_table :guests do |t|
      t.string :email, index: { unique: true }
      t.string :first_name
      t.string :last_name
      t.string :phone_numbers, array: true, default: []
      t.timestamps
    end
  end
end
