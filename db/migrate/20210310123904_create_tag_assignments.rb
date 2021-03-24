class CreateTagAssignments < ActiveRecord::Migration[6.1]
  def change
    create_table :tag_assignments do |t|
      t.float :weight
      t.belongs_to :tag
      t.belongs_to :resource

      t.timestamps
    end
  end
end
