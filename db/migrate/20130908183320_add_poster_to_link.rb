class AddPosterToLink < ActiveRecord::Migration
  def change
    add_column :links, :poster, :string
  end
end
