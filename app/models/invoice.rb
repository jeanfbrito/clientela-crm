# -*- encoding : utf-8 -*-
class Invoice < ActiveResource::Base
  self.site = "https://app.cobregratis.com.br/"
  self.element_name = "bank_billet"
  self.user = "nbEPn70fR0Seutb1sYFr"
  self.password = "X"

  class << self
    def deliver(account)
      invoice = Invoice.new(
        :service_id => 102,
        :amount => "70,00",
        :name => account.admin_name,
        :expire_at => 10.days.from_now,
        :description => description(account.domain),
        :instructions => "Não receber após o vencimento."
      )
      invoice.meta = {"account_id" => account.id}
      invoice.email = {:address => account.admin_email, :name => account.admin_name, :from_address => "contato@clientela.com.br", :from_name => "Clientela"}
      invoice.save
      sleep(2)
    end

    private
    def description(domain)
      %{
Clientela referente ao mês de #{I18n.l(1.day.from_now, :format => :month_year)}. Esta é uma cobrança automática. Em caso de dúvidas envie um e-mail para contato@clientela.com.br.

O link de acesso para sua conta é http://#{Clientela::Base.url(domain)}.

Agradecemos por utilizar o Clientela!}
    end
  end
end
