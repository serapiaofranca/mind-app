class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      enable_extension('citext')   #enable extension ignore case-sensitive

      t.citext :name  #modify type string to citext to use extension 
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end    
    
    add_index :tags, [:name, :user_id], unique: true    #join tag-name for user 
  end
end
