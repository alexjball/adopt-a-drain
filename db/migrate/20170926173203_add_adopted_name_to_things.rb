# frozen_string_literal: true

class AddAdoptedNameToThings < ActiveRecord::Migration[4.2]
  def up
    add_column :things, :adopted_name, :string

    execute <<-SQL
      UPDATE things SET adopted_name = name WHERE user_id IS NOT NULL;
    SQL
  end

  def down
    remove_column :things, :adopted_name, :string
  end
end
