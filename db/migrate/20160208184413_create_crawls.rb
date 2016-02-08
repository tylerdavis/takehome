class CreateCrawls < ActiveRecord::Migration
  def up
    create_table :crawls do |t|
      t.text :url, null: false
      t.boolean :in_progress, null: false, default: true
      t.text :images
      t.integer :crawl_id
      t.integer :job_id

      t.timestamps null: false
    end

    create_table :jobs do |t|
      t.timestamps
    end

    add_index :crawls, [:job_id]
    add_index :crawls, [:crawl_id]
  end

  def down
    drop_table :crawls
    drop_table :jobs
  end
end
