class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :name,         :limit => 100, :null => false, :default => ""
      t.boolean :active,      :default => true
      t.references :project,  :foreign_key => true

      t.timestamps
    end
    add_index :clients, :name, unique: true
  end
end
