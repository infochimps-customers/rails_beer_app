class CreateBeers < ActiveRecord::Migration
  def self.up
    create_table :beers do |t|
      t.string     :title
      t.text       :description
      t.float      :price
      t.string     :image_link
      t.string     :metro_name
      t.timestamps
    end
    add_index :beers, [:price]
  end

  def self.down
    drop_table :products
  end
end
