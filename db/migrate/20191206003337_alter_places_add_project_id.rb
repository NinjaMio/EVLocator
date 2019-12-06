class AlterPlacesAddProjectId < ActiveRecord::Migration[5.2]
  def change
    add_column :places, :project_id, :integer
    add_index :places, :project_id
  end
end
