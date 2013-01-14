require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HooksController do
  describe "POST wufoo" do
    context "no HandshakeKey is given" do
      it "should ignore and return 401" do
        post :wufoo
        response.code.should == "401"
      end
    end

    context "HandshakeKey is given" do
      let!(:user) { FactoryGirl.create(:quentin) }
      let!(:contact) { FactoryGirl.create(:contact_joseph, imported_by: nil, emails: [FactoryGirl.create(:email)], phones: [FactoryGirl.create(:phone)], tag_list: ["Partner"]) }
      let(:params) { {"HandshakeKey"=>"#{user.authentication_token}", "Field4"=>"21 8106-9960", "Field5"=>"any@email.com", "DateCreated"=>"2011-09-21 16:13:48", "EntryId"=>"2", "IP"=>"189.24.97.217", "CreatedBy"=>"public", "Field11"=>"Sylvestre Mergulhao"} }

      def do_post
        post :wufoo, params
      end

      it "should be success" do
        do_post
        response.should be_success
      end

      context "contact email already exists" do
        def params_email_exists
          params.merge({"Field5"=>"amorin@example.com"})
        end

        def do_post
          post :wufoo, params_email_exists
        end

        it "should not create a new contact" do
          lambda do
            do_post
          end.should_not change(Contact, :count)
        end

        it "should not create a new deal assigned to this contact" do
          lambda do
            do_post
          end.should_not change(Contact, :count)
        end

        describe "tasks" do
          let(:tomorrow_at_18pm) { (1.day.from_now.end_of_day - 6.hours + 1.second).to_a }

          it "should create follow-up task" do
            lambda do
              do_post
            end.should change(Task, :count).by(1)
          end

          it "should create a task for tomorrow" do
            do_post
            task = Task.find_by_content!("Contato pelo site")
            task.due_at.to_a.should == tomorrow_at_18pm
            task.content.should == "Contato pelo site"
            task.taskable.should == contact
            task.assigned_to.should == user
          end
        end
      end

      context "contact email doesnt exists" do
        def params_email_not_exists
          params.merge({"Field5"=>"mergulhao@helabs.com.br"})
        end

        def do_post
          post :wufoo, params_email_not_exists
        end

        describe "contact" do
          it "should create the new contact" do
            lambda do
              do_post
            end.should change(Contact, :count).by(1)
          end

          it "should assign correct contact name" do
            do_post
            Contact.last.name.should == "Sylvestre Mergulhao"
          end

          it "should create the contact phone" do
            do_post
            phone = Phone.last
            phone.number.should == "21 8106-9960"
            phone.kind.should == "work"
          end

          it "should create the contact email" do
            do_post
            email = Email.last
            email.address.should == "mergulhao@helabs.com.br"
            email.kind.should == "work"
          end
        end

        describe "deals" do
          it "should create deal" do
            lambda do
              do_post
            end.should change(Deal, :count).by(1)
          end

          it "should assign the created deal to the created contact" do
            do_post
            deal = Deal.last
            deal.name.should == "Startup DEV - Sylvestre Mergulhao"
            deal.description.should be_nil
            deal.value.should == 6000
            deal.status.should == "prospect"
            deal.value_type.should == "fixed"
            deal.assigned_to.should == user
            deal.probability.should == 50
          end
        end

        describe "tasks" do
          let(:tomorrow_at_18pm) { (1.day.from_now.end_of_day - 6.hours + 1.second).to_a }

          it "should create follow-up task" do
            lambda do
              do_post
            end.should change(Task, :count).by(1)
          end

          it "should create a task for tomorrow" do
            do_post
            task = Task.find_by_content!("Contato pelo site")
            task.due_at.to_a.should == tomorrow_at_18pm
            task.content.should == "Contato pelo site"
            task.taskable.should == Contact.last
            task.assigned_to.should == user
          end
        end
      end
    end
  end
end
