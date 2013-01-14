# encoding: UTF-8
FactoryGirl.define do
  factory :deal do
    assigned_to { FactoryGirl.create(:quentin) }
    
    factory :quentin_deal_won do
      name "deal ganha do quentin"
      description "deal de teste"
      value "1000"
      value_type "monthly"
      status "won"
      duration "10"
      status_last_change_at "2011-10-10 10:10:10"
      updated_at "2011-10-10 10:10:10"
      created_at "2011-09-10 10:10:10"
    end

    factory :quentin_deal_lost do
      name "deal perdida do quentin"
      description "deal de teste"
      value_type "fixed"
      value "10"
      status "lost"
      created_at "2011-08-10 10:10:10"
    end

    factory :quentin_deal_pending do
      name "deal pendente do quentin"
      description "deal de teste"
      value "10"
      value_type "fixed"
      status "prospect"
      status_last_change_at "<%= 0.days.from_now %>"
      created_at "2011-08-10 10:10:10"
    end

    factory :quentin_0_0 do
      name "processos"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 76756"
      value_type "fixed"
      duration "6"
      status "won"
      created_at "2011-07-21 16:28:08 UTC"
    end

    factory :quentin_0_1 do
      name "controle"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 3701"
      value_type "fixed"
      duration "6"
      status "lost"
      created_at "2011-07-21 16:28:08 UTC"
    end

    factory :quentin_0_2 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 61941"
      value_type "monthly"
      duration "6"
      status "won"
      created_at "2011-07-21 16:28:08 UTC"
    end

    factory :quentin_0_3 do
      name "Sistema"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 8615"
      value_type "monthly"
      duration "6"
      status "prospect"
      created_at "2011-07-21 16:28:08 UTC"
    end

    factory :quentin_0_4 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 86614"
      value_type "hourly"
      duration "6"
      status "lost"
      created_at "2011-07-21 16:28:08 UTC"
    end

    factory :quentin_1_0 do
      name "Sistema"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 22106"
      value_type "yearly"
      duration "6"
      status "prospect"
      created_at "2011-06-21 16:28:08 UTC"
    end

    factory :quentin_1_1 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 80573"
      value_type "hourly"
      duration "6"
      status "won"
      created_at "2011-06-21 16:28:08 UTC"
    end

    factory :quentin_1_2 do
      name "processos"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 48329"
      value_type "fixed"
      duration "6"
      status "lost"
      created_at "2011-06-21 16:28:08 UTC"
    end

    factory :quentin_1_3 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 85720"
      value_type "hourly"
      duration "6"
      status "lost"
      created_at "2011-06-21 16:28:08 UTC"
    end

    factory :quentin_1_4 do
      name "controle"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 8340"
      value_type "hourly"
      duration "6"
      status "won"
      created_at "2011-06-21 16:28:08 UTC"
    end

    factory :quentin_2_0 do
      name "Sistema"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 7162"
      value_type "yearly"
      duration "6"
      status "won"
      created_at "2011-05-21 16:28:08 UTC"
    end

    factory :quentin_2_1 do
      name "controle"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 56011"
      value_type "monthly"
      duration "6"
      status "lost"
      created_at "2011-05-21 16:28:08 UTC"
    end

    factory :quentin_2_2 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 21551"
      value_type "yearly"
      duration "6"
      status "lost"
      created_at "2011-05-21 16:28:08 UTC"
    end

    factory :quentin_2_3 do
      name "processos"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 38254"
      value_type "hourly"
      duration "6"
      status "prospect"
      created_at "2011-05-21 16:28:08 UTC"
    end

    factory :quentin_2_4 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 26004"
      value_type "fixed"
      duration "6"
      status "lost"
      created_at "2011-05-21 16:28:08 UTC"
    end

    factory :quentin_3_0 do
      name "controle"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 62121"
      value_type "fixed"
      duration "6"
      status "lost"
      created_at "2011-04-21 16:28:08 UTC"
    end

    factory :quentin_3_1 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 70778"
      value_type "yearly"
      duration "6"
      status "lost"
      created_at "2011-04-21 16:28:08 UTC"
    end

    factory :quentin_3_2 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 28161"
      value_type "hourly"
      duration "6"
      status "won"
      created_at "2011-04-21 16:28:08 UTC"
    end

    factory :quentin_3_3 do
      name "Sistema"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 90419"
      value_type "yearly"
      duration "6"
      status "lost"
      created_at "2011-04-21 16:28:08 UTC"
    end
    factory :quentin_3_4 do
      name "processos"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 24097"
      value_type "monthly"
      duration "6"
      status "lost"
      created_at "2011-04-21 16:28:08 UTC"
    end
    factory :quentin_4_0 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 48225"
      value_type "monthly"
      duration "6"
      status "prospect"
      created_at "2011-03-21 16:28:08 UTC"
    end
    factory :quentin_4_1 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 60066"
      value_type "hourly"
      duration "6"
      status "lost"
      created_at "2011-03-21 16:28:08 UTC"
    end
    factory :quentin_4_2 do
      name "controle"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 27608"
      value_type "fixed"
      duration "6"
      status "lost"
      created_at "2011-03-21 16:28:08 UTC"
    end
    factory :quentin_4_3 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 42683"
      value_type "hourly"
      duration "6"
      status "lost"
      created_at "2011-03-21 16:28:08 UTC"
    end
    factory :quentin_4_4 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 5659"
      value_type "yearly"
      duration "6"
      status "prospect"
      created_at "2011-03-21 16:28:08 UTC"
    end
    factory :quentin_5_0 do
      name "processos"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 28033"
      value_type "monthly"
      duration "6"
      status "won"
      created_at "2011-02-21 16:28:08 UTC"
    end
    factory :quentin_5_1 do
      name "controle"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 93299"
      value_type "yearly"
      duration "6"
      status "lost"
      created_at "2011-02-21 16:28:08 UTC"
    end
    factory :quentin_5_2 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 44241"
      value_type "fixed"
      duration "6"
      status "won"
      created_at "2011-02-21 16:28:08 UTC"
    end
    factory :quentin_5_3 do
      name "controle"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 37775"
      value_type "monthly"
      duration "6"
      status "lost"
      created_at "2011-02-21 16:28:08 UTC"
    end
    factory :quentin_5_4 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 21416"
      value_type "hourly"
      duration "6"
      status "won"
      created_at "2011-02-21 16:28:08 UTC"
    end
    factory :quentin_6_0 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 62079"
      value_type "monthly"
      duration "6"
      status "prospect"
      created_at "2011-01-21 16:28:08 UTC"
    end
    factory :quentin_6_1 do
      name "Sistema"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 38011"
      value_type "yearly"
      duration "6"
      status "lost"
      created_at "2011-01-21 16:28:08 UTC"
    end
    factory :quentin_6_2 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 4606"
      value_type "hourly"
      duration "6"
      status "lost"
      created_at "2011-01-21 16:28:08 UTC"
    end
    factory :quentin_6_3 do
      name "controle"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 74947"
      value_type "hourly"
      duration "6"
      status "won"
      created_at "2011-01-21 16:28:08 UTC"
    end
    factory :quentin_6_4 do
      name "processos"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 29759"
      value_type "monthly"
      duration "6"
      status "prospect"
      created_at "2011-01-21 16:28:08 UTC"
    end
    factory :quentin_7_0 do
      name "controle"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 92709"
      value_type "monthly"
      duration "6"
      status "lost"
      created_at "2010-12-21 16:28:08 UTC"
    end
    factory :quentin_7_1 do
      name "processos"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 71963"
      value_type "yearly"
      duration "6"
      status "lost"
      created_at "2010-12-21 16:28:08 UTC"
    end
    factory :quentin_7_2 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 19387"
      value_type "yearly"
      duration "6"
      status "lost"
      created_at "2010-12-21 16:28:08 UTC"
    end
    factory :quentin_7_3 do
      name "controle"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 85833"
      value_type "fixed"
      duration "6"
      status "lost"
      created_at "2010-12-21 16:28:08 UTC"
    end
    factory :quentin_7_4 do
      name "Sistema"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 9756"
      value_type "hourly"
      duration "6"
      status "prospect"
      created_at "2010-12-21 16:28:08 UTC"
    end
    factory :quentin_8_0 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 2337"
      value_type "monthly"
      duration "6"
      status "prospect"
      created_at "2010-11-21 16:28:08 UTC"
    end
    factory :quentin_8_1 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 46076"
      value_type "fixed"
      duration "6"
      status "prospect"
      created_at "2010-11-21 16:28:08 UTC"
    end
    factory :quentin_8_2 do
      name "Sistema"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 65860"
      value_type "yearly"
      duration "6"
      status "won"
      created_at "2010-11-21 16:28:08 UTC"
    end
    factory :quentin_8_3 do
      name "Sistema"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 73844"
      value_type "hourly"
      duration "6"
      status "won"
      created_at "2010-11-21 16:28:08 UTC"
    end
    factory :quentin_8_4 do
      name "Sistema"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 4689"
      value_type "monthly"
      duration "6"
      status "won"
      created_at "2010-11-21 16:28:08 UTC"
    end
    factory :quentin_9_0 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 1751"
      value_type "hourly"
      duration "6"
      status "won"
      created_at "2010-10-21 16:28:08 UTC"
    end
    factory :quentin_9_1 do
      name "processos"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 98402"
      value_type "monthly"
      duration "6"
      status "lost"
      created_at "2010-10-21 16:28:08 UTC"
    end
    factory :quentin_9_2 do
      name "controle"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 70298"
      value_type "monthly"
      duration "6"
      status "prospect"
      created_at "2010-10-21 16:28:08 UTC"
    end
    factory :quentin_9_3 do
      name "processos"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 38164"
      value_type "fixed"
      duration "6"
      status "won"
      created_at "2010-10-21 16:28:08 UTC"
    end
    factory :quentin_9_4 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 76437"
      value_type "yearly"
      duration "6"
      status "lost"
      created_at "2010-10-21 16:28:08 UTC"
    end
    factory :quentin_10_0 do
      name "controle"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 45726"
      value_type "hourly"
      duration "6"
      status "prospect"
      created_at "2010-09-21 16:28:08 UTC"
    end
    factory :quentin_10_1 do
      name "Sistema"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 35026"
      value_type "monthly"
      duration "6"
      status "prospect"
      created_at "2010-09-21 16:28:08 UTC"
    end
    factory :quentin_10_2 do
      name "processos"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 61762"
      value_type "yearly"
      duration "6"
      status "won"
      created_at "2010-09-21 16:28:08 UTC"
    end
    factory :quentin_10_3 do
      name "Sistema"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 73357"
      value_type "hourly"
      duration "6"
      status "lost"
      created_at "2010-09-21 16:28:08 UTC"
    end
    factory :quentin_10_4 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 11775"
      value_type "yearly"
      duration "6"
      status "won"
      created_at "2010-09-21 16:28:08 UTC"
    end
    factory :quentin_11_0 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 98449"
      value_type "fixed"
      duration "6"
      status "won"
      created_at "2010-08-21 16:28:08 UTC"
    end
    factory :quentin_11_1 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 21120"
      value_type "fixed"
      duration "6"
      status "won"
      created_at "2010-08-21 16:28:08 UTC"
    end
    factory :quentin_11_2 do
      name "processos"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 61279"
      value_type "hourly"
      duration "6"
      status "prospect"
      created_at "2010-08-21 16:28:08 UTC"
    end
    factory :quentin_11_3 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 27804"
      value_type "hourly"
      duration "6"
      status "won"
      created_at "2010-08-21 16:28:08 UTC"
    end
    factory :quentin_11_4 do
      name "de"
      description "Empresa de maquinário hidráulico contratou a Helabs para o desenvolvimento de um sistema de controle de processos da sua produção. O projeto segue o modelo de contrato de escopo variável."
      value " 19545"
      value_type "yearly"
      duration "6"
      status "prospect"
      created_at "2010-08-21 16:28:08 UTC"
    end
  end
end