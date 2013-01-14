# -*- encoding : utf-8 -*-
@contacts = ['Dimas Cyriaco', 'Pedro Marins', 'Sylvestre Mergulhao', 'Helmuth Gair', 'Jose Da Silva', 'Quentin Tarantino', 'Vinicius Teles', 'Henrique Bastos', 'Ramon Page', 'Rodrigo Pinto', 'Ramon Tauil']
@facts = [
  { :name => "Carga não chegou no destino a tempo", :description => "Transportadora: Manuel Transporte LTDA\nOS: 1234666\nNúmero nota fiscal: 12930" },
  { :name => "Sistema saiu do ar no Carnaval", :description => "Ticket: #12345\n\nE ai não funcionou mais..." }
]
@companies = %w{Helabs horaextra IBM Microsoft Apple Cannonical FSF}
@tags = %w{gerente programador dono clt estagiario pj designer desenvolvimento diretor rio_de_janeiro sao_paulo niteroi autonomo freelancer dba arquiteto}
@titles = %w{Gerente Dono Diretor Supervisor Desenvolvedor Designer Estagiario DBA}

Company.delete_all
Contact.delete_all
Task.delete_all
Deal.delete_all
Fact.delete_all
ActsAsTaggableOn::Tag.delete_all
ActsAsTaggableOn::Tagging.delete_all
Note.delete_all
Phone.delete_all
Email.delete_all
Activity.delete_all
User.delete_all
TaskCategory.delete_all
Account.delete_all

User.new(:name => "Quentin Tarantino", :email => "quentin@example.com", :password => "test").save(false)
quentin = User.first
Thread.current[:current_user] = quentin.id

Account.new(:name => "Example", :domain => nil, :goal_quantitative => 25, :goal_qualitative => 4000000).save(false)
Account.current = Account.first

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

def random_task_category
  TaskCategory.all.sort_by{ rand }.first
end

def random_tags
  qtd = [2, 3, 4].sort_by { rand }.first
  @tags.sort_by { rand }.first(qtd)
end

def random_title
  @titles << nil
  @titles.sort_by{ rand }.first
end

def random_email_kind
  Email.kinds.sort_by { rand }.first
end

def random_phone_kind
  Phone.kinds.sort_by { rand }.first
end

def random_company
  Company.all.sort_by { rand }.first
end

def random_contact
  Contact.all.sort_by { rand }.first
end

def random_phone
  "#{rand(8999)+1000}-#{rand(9999)}"
end

def random_value_type
  values = %w(fixed hourly monthly yearly)
  values[rand(values.size)]
end

def random_deal_name
  names = %w{Sistema de controle de processos}
  names[rand(names.size)]
end

def random_deal_status
  names = %w{prospect qualify proposal negotiation lost won}
  names[rand(names.size)]
end

@companies.each do |company|
  Company.create( :name     => company,
                  :tag_list => random_tags)
end

@contacts.each do |contact|
  company = random_company
  Contact.create( :name               => contact,
                  :title              => random_title,
                  :tag_list           => random_tags,
                  :company            => company,
                  :emails_attributes  => [{ :address  => "#{contact.downcase.gsub(" ", ".")}@#{company.name.downcase}.com",
                                            :kind     => random_email_kind}],
                  :phones_attributes  => [{ :number => random_phone,
                                            :kind   => random_phone_kind}] )
end

12.times do |i|
  10.times do
    deal = Deal.new(:name         => "#{random_deal_name} #{random_deal_name} #{random_deal_name}",
                :description  => "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável.",
                :value        => "#{rand(100000)}",
                :value_type   => random_value_type,
                :duration     => 6,
                :tag_list     => random_tags,
                :status       => random_deal_status,
                :assigned_to  => quentin)
    deal.created_at  = i.months.ago
    deal.save!
  end
end

contact = Contact.find_by_name('Sylvestre Mergulhão')
deal = Deal.first
[
  ['Ligar para o Dimas', Time.now, contact],
  ['Reunião com o cliente', Time.now - 1.day, contact],
  ['Apresentação da proposta', Time.now + 1.day, contact],
  ['Agendar reunião de planejamento', Time.now, deal],
  ['Mandar proposta de orçamento', Time.now - 1.day, deal],
  ['Reunir clientes com equipe de desenvolvimento', Time.now + 1.day, deal],
].each do |content, due_at, taskable|
  Task.create(
    :due_at      => due_at,
    :assigned_to => quentin,
    :created_by  => quentin,
    :taskable    => taskable,
    :category    => random_task_category,
    :content     => content
  )
end


Task.create(:due_at   => Time.now,
            :content  => 'Entrar em contato com o patrocinador',
            :done_at  => 2.months.ago)
Task.create(:due_at   => Time.now,
            :content  => 'Almoçar com o cliente')
Task.create(:due_at   => Time.now - 1.day,
            :content  => 'Comprar suprimentos para o escritório',
            :done_at  => 1.month.ago)
Task.create(:due_at   => Time.now - 1.day,
            :content  => 'Instalar a persiana')
Task.create(:due_at   => Time.now + 1.day,
            :content  => 'Mandar HD para a garantia')
Task.create(:due_at   => Time.now + 1.day,
            :content  => 'Comprar estação de trabalho',
            :done_at  => 3.months.ago)

Note.create(:notable => Deal.first,
            :content => 'Lista de requisitos foi atualizada com as novas demandas do cliente')
Note.create(:notable => Deal.first,
            :content => 'Contato realizado para remarcar proxima reunião')
Note.create(:notable => Deal.first,
            :content => 'Ligação para o cliente não completava')

@facts.each do |fact|
  fact = Fact.create(fact)
  fact.contacts << Contact.first
end
