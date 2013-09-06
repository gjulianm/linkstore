class AddUrlDataToLink < ActiveRecord::Migration
  def change
    add_column :links, :domain, :string
    add_column :links, :title, :string
  end
end
