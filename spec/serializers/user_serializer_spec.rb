# frozen_string_literal: true

RSpec.describe UserSerializer do
  fab!(:user)

  def serialize(user)
    described_class.new(user, scope: Guardian.new(user), root: false).as_json
  end

  it "reports daily summaries as disabled without storing a value for users who never set it" do
    expect(serialize(user)[:user_mlm_daily_summary_enabled]).to eq(false)
    expect(
      UserCustomField.exists?(
        user_id: user.id,
        name: "user_mlm_daily_summary_enabled"
      )
    ).to eq(false)
  end

  it "reports daily summaries as enabled for both stored true formats" do
    other_user = Fabricate(:user)
    UserCustomField.create!(
      user: user,
      name: "user_mlm_daily_summary_enabled",
      value: "t"
    )
    UserCustomField.create!(
      user: other_user,
      name: "user_mlm_daily_summary_enabled",
      value: "true"
    )

    expect(serialize(user.reload)[:user_mlm_daily_summary_enabled]).to eq(true)
    expect(serialize(other_user.reload)[:user_mlm_daily_summary_enabled]).to eq(
      true
    )
  end
end
