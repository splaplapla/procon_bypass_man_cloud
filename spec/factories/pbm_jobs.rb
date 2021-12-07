FactoryBot.define do
  factory :pbm_job do
    device
    uuid { PbmJob.generate_uuid }
    args { {} }
    status { :queued }

    trait :action_reboot_os do
      action { :reboot_os }
    end
  end
end
