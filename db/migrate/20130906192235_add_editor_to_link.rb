class AddEditorToLink < ActiveRecord::Migration
  def change
    add_column :links, :editor, :string
  end
end
