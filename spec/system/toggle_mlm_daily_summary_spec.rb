# frozen_string_literal: true

RSpec.describe "Toggle MLM daily summary" do
  fab!(:user)

  let(:preferences_page) { PageObjects::Pages::MlmDailySummaryPreferences.new }

  before do
    SiteSetting.mlm_daily_summary_enabled = true
    sign_in(user)
  end

  it "lets the user enable daily summaries from their email preferences" do
    preferences_page.visit(user)
    expect(preferences_page).to have_daily_summary_unchecked

    preferences_page.toggle_daily_summary.save
    expect(preferences_page).to have_saved_message

    page.refresh
    expect(preferences_page).to have_daily_summary_checked
  end
end
