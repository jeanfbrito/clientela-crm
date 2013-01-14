# encoding: utf-8
class AddTaskCategoriesSeed < ActiveRecord::Migration
  def self.up
    [
      ["Ligação", '000099'],
      ["E-mail", 'FF9C00'],
      ["Fax", 'C50000'],
      ["Retorno", '009900'],
      ["Almoço", '3185C5'],
      ["Reunião", 'E207C1'],
      ["Envio", '3B9E93'],
      ["Agradecimento", '46647C']
    ].each do |name, color|
      TaskCategory.create(:name => name, :color => color)
    end
  end

  def self.down
    execute "truncate task_categories"
  end
end
