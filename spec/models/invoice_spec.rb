require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Invoice do
  let!(:account) { FactoryGirl.create(:example) }
  let!(:user) { FactoryGirl.create(:quentin) }
  describe "deliver" do
    describe "mocking request" do
      before do
        FakeWeb.register_uri(:post, "https://nbEPn70fR0Seutb1sYFr:X@app.cobregratis.com.br/bank_billets.xml", :status => ["200", "OK"])
      end

      it "should test" do
        Invoice.deliver(account).should be_true
      end
    end

    describe "mocking invoice"do
      def invoice
        @invoice ||= mock('invoice')
      end

      it "should create an Invoice using data from account" do
        Invoice.should_receive(:new).with(hash_including(
          :service_id=>102,
          :name=>"Quentin Tarantino",
          :amount=>"70,00")
        ).and_return(invoice)

        invoice.should_receive(:meta=).with({"account_id"=>account.id})
        invoice.should_receive(:email=).with({:address=>"#{user.email}", :from_address=>"contato@clientela.com.br", :name=>"Quentin Tarantino", :from_name=>"Clientela"})
        invoice.should_receive(:save)

        Invoice.deliver(account)
      end
    end
  end
end
