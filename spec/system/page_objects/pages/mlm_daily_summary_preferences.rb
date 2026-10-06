# frozen_string_literal: true

module PageObjects
  module Pages
    class MlmDailySummaryPreferences < PageObjects::Pages::Base
      CHECKBOX = ".mlm-daily-summary input[type='checkbox']"

      def visit(user)
        page.visit("/u/#{user.username}/preferences/emails")
        self
      end

      def toggle_daily_summary
        page.find(CHECKBOX).click
        self
      end

      def save
        page.find(".save-changes").click
        self
      end

      def has_daily_summary_checked?
        page.has_css?("#{CHECKBOX}:checked")
      end

      def has_daily_summary_unchecked?
        page.has_css?("#{CHECKBOX}:not(:checked)")
      end

      def has_saved_message?
        page.has_css?(".save-button .saved")
      end
    end
  end
end
