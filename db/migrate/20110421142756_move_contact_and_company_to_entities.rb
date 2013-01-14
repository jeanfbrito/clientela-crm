class MoveContactAndCompanyToEntities < ActiveRecord::Migration
  def self.up
    transaction do
      execute("SELECT id, name, created_at, updated_at FROM companies").each do |row|
        id = insert_sql(sanitize(["INSERT INTO contacts (name,type,created_at,updated_at) VALUES (?,?,?,?)", row[1], "Company", row[2], row[3]]))
        execute("UPDATE taggings SET taggable_id = #{id} WHERE taggable_id = #{row[0]} AND taggable_type = 'Company'")
        execute("UPDATE contacts SET company_id = #{id} WHERE company_id = #{row[0]}")
      end
      execute("UPDATE taggings SET taggable_type = 'Entity' where taggable_type in ('Company', 'Contact')")
      execute("UPDATE notes SET notable_type = 'Entity' where notable_type = 'Contact'")
      execute("UPDATE tasks SET taskable_type = 'Entity' where taskable_type = 'Contact'")
    end
    execute("RENAME TABLE contacts TO entities")
  end

  def self.down
    execute("RENAME TABLE entities TO contacts")
    transaction do
      execute("SELECT id, name, created_at, updated_at FROM contacts WHERE type = 'Company'").each do |row|
        id = insert_sql(sanitize(["INSERT INTO companies (name,created_at,updated_at) VALUES (?,?,?)", row[1], row[2], row[3]]))
        execute("UPDATE taggings SET taggable_id = #{id}, taggable_type = 'Company' WHERE taggable_id = #{row[0]} AND taggable_type = 'Entity'")
        execute("UPDATE contacts SET company_id = #{id} WHERE company_id = #{row[0]}")
        execute("DELETE FROM contacts WHERE id = #{row[0]}")
      end
      execute("UPDATE taggings SET taggable_type = 'Contact' where taggable_type = 'Entity'")
      execute("UPDATE notes SET notable_type = 'Contact' where notable_type = 'Entity'")
      execute("UPDATE tasks SET taskable_type = 'Contact' where taskable_type = 'Entity'")
    end
  end

  def self.sanitize(sql)
    ActiveRecord::Base.send(:sanitize_sql_array, sql)
  end
end
