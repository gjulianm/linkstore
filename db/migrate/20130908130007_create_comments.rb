class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :author
      t.string :text
      t.references :link, index: true

      t.timestamps
    end
  end
end
