class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name,     :limit => 100, :null => false, :default => ""
      t.boolean :active,  :default => true

      t.timestamps
    end
    add_index :projects, :name, unique: true
  end
end
