class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.belongs_to :tag_category

      t.timestamps
    end
  end
end
