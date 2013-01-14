# encoding: UTF-8
FactoryGirl.define do
  factory :task do
    created_by { FactoryGirl.create(:user) }

    factory :not_specified_datetime do
      due_at {7.days.from_now.end_of_week.to_s}
      content "blas"
      frame "false"
      assigned_to { FactoryGirl.create(:quentin) }
      taskable { FactoryGirl.create(:contact_joseph, imported_by_id: nil) }
    end

    factory :specified_datetime do
      due_at {7.days.from_now.to_s}
      content "blas"
      frame "true"
      assigned_to { FactoryGirl.create(:quentin) }
    end

    factory :task_today do
      due_at {Time.now.to_s}
      content "blas"
      assigned_to { FactoryGirl.create(:quentin) }
      taskable_type ""
    end

    factory :task_today_done do
      taskable { FactoryGirl.create(:entity_quentin)}
      due_at {Time.now.to_s}
      content "blas"
      done_at {2.month.ago}
      assigned_to { FactoryGirl.create(:quentin) }
    end

    factory :task_yesterday_done do
      taskable { FactoryGirl.create(:entity_helabs)}
      due_at {1.days.ago.to_s}
      content "blas"
      done_at {2.month.ago}
      assigned_to { FactoryGirl.create(:quentin) }
    end

    factory :task_tomorrow do
      taskable { FactoryGirl.create(:quentin_deal_won) }
      due_at {1.days.from_now.to_s}
      content "blas"
      assigned_to { FactoryGirl.create(:quentin) }
    end

    factory :task_tomorrow_done do
      taskable { FactoryGirl.create(:fact) }
      due_at {1.days.from_now.to_s}
      content "blas"
      done_at {2.month.ago}
      assigned_to { FactoryGirl.create(:quentin) }
    end

    factory :task_pending do
      taskable { FactoryGirl.create(:contact_joseph) }
      due_at {2.days.ago.to_s}
      content "falta fazer"
      notified "true"
      assigned_to { FactoryGirl.create(:quentin) }
    end
  end
end