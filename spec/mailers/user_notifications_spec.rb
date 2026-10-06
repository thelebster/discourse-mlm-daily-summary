# frozen_string_literal: true

RSpec.describe UserNotifications do
  describe ".mailing_list" do
    fab!(:user)
    fab!(:author) { Fabricate(:user, trust_level: TrustLevel[1]) }
    # Older than the editing grace period, so core's digest query includes it.
    fab!(:topic) { Fabricate(:topic, user: author, created_at: 1.hour.ago) }
    fab!(:post) do
      Fabricate(:post, topic: topic, user: author, created_at: 1.hour.ago)
    end

    it "builds the daily summary while the plugin setting is on" do
      SiteSetting.mlm_daily_summary_enabled = true

      email = described_class.mailing_list(user, since: 1.day.ago).message

      expect(email.to).to eq([user.email])
    end

    it "builds no email when the plugin setting is turned off" do
      SiteSetting.mlm_daily_summary_enabled = false

      email = described_class.mailing_list(user, since: 1.day.ago).message

      expect(email.to).to be_blank
    end
  end
end
