class AddPriorityToLink < ActiveRecord::Migration
  def change
    add_column :links, :priority, :int
  end
end
