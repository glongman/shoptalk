class AddTimezoneAndName < ActiveRecord::Migration
  def self.up
    change_table :shops do |t|
      t.string :timezone
      t.string :name
    end
  end

  def self.down
    change_table :shops do |t|
      t.remove :timezone
      t.remove :name
    end
  end
end
