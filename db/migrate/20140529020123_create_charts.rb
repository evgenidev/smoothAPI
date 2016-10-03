class CreateCharts < ActiveRecord::Migration
  def change
    create_table :charts do |t|
      t.integer :risk_score
      t.string :asset_class
      t.string :investment_fund
      t.integer :weight
      t.string :ticker

      t.timestamps
    end
  end
end
