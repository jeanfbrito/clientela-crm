class UpdateTaskCategoryValueOfEnvioToCarta < ActiveRecord::Migration
  def self.up
    TaskCategory.find_by_name("Envio").update_attribute(:name,"Carta")
  end

  def self.down
    TaskCategory.find_by_name("Carta").update_attribute(:name,"Envio")
  end
end
