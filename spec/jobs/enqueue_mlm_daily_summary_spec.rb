# frozen_string_literal: true

RSpec.describe Jobs::EnqueueMlmDailySummary do
  let(:field_name) { "user_mlm_daily_summary_enabled" }

  before { SiteSetting.disable_mailing_list_mode = false }

  def user_with_stored_value(value)
    user = Fabricate(:user, first_seen_at: 2.days.ago)
    UserCustomField.create!(user: user, name: field_name, value: value)
    user
  end

  describe "#execute" do
    it "enqueues the summary for users who enabled it, whether stored as 't' or legacy 'true'" do
      freeze_time

      current_format_user = user_with_stored_value("t")
      legacy_format_user = user_with_stored_value("true")
      user_with_stored_value("f")
      user_with_stored_value("false")

      described_class.new.execute({})

      enqueued = Jobs::UserEmail.jobs.map { |job| job["args"].first }
      expect(enqueued.map { |args| args["user_id"] }).to contain_exactly(
        current_format_user.id,
        legacy_format_user.id
      )
      expect(enqueued.map { |args| args["type"] }).to all(eq("mailing_list"))
    end

    it "enqueues nothing when mailing list mode is disabled" do
      freeze_time
      user_with_stored_value("t")
      SiteSetting.disable_mailing_list_mode = true

      described_class.new.execute({})

      expect(Jobs::UserEmail.jobs).to be_empty
    end

    it "enqueues nothing when the plugin setting is turned off" do
      freeze_time
      user_with_stored_value("t")
      SiteSetting.mlm_daily_summary_enabled = false

      described_class.new.execute({})

      expect(Jobs::UserEmail.jobs).to be_empty
    end
  end
end
