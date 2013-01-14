# -*- encoding : utf-8 -*-
namespace :import do
  task :contacts => :environment do
    Account.current = Account.find_by_domain('cursoradix')
    Account.current.configure!
    
    require 'csv'
    CSV.foreach("#{Rails.root}/Radix.csv") do |row|
#      puts row[1] # nome
#      puts row[2] # telefone
#      puts row[3] # estado
#      puts row[4] # cidade
#      puts row[5] # graduação  
#      puts row[6] # Você acessa a Internet em que locais?
#      puts row[7] # Em relação aos seus hábitos de estudos para concursos públicos na área de Comunicação Social, você diria que:
#      puts row[8] # Você tem interesse em que tipo de aula / material didático?
#      puts row[9] # Observações
#      puts row[10] # Estudou em Universidade
#      puts row[11] # Email

      contact = Contact.create!(
        :name => row[1],
        :phones_attributes => [{:number => row[2], :kind => "home"}],
        :addresses_attributes => [{:city => row[4], :state => row[3], :kind => "home"}],
        :emails_attributes => [{:address => row[11], :kind => "home"}]
      )
      contact.notes << Note.new(:author => User.first,:content => %{# Graduação:

#{row[5]}

# Você acessa a Internet em que locais?

#{row[6]}

# Em relação aos seus hábitos de estudos para concursos públicos na área de Comunicação Social, você diria que:

#{row[7]}

# Você tem interesse em que tipo de aula / material didático?

#{row[8]}

# Estudou em Universidade

#{row[10]}

# Observações

#{row[9]}})
    end
  end
end