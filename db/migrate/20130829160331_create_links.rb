class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :url
      t.boolean :done
      t.text :description

      t.timestamps
    end
  end
end
