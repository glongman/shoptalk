class AddTokenToShop < ActiveRecord::Migration
  def self.up
    change_table :shops do |t|
      t.string :token
    end
  end

  def self.down
    change_table :shops do |t|
      t.remove :token
    end
  end
end
