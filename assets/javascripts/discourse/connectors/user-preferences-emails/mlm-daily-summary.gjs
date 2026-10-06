import Component from "@glimmer/component";
import { service } from "@ember/service";
import PreferenceCheckbox from "discourse/components/preference-checkbox";
import { i18n } from "discourse-i18n";

export default class MlmDailySummary extends Component {
  @service siteSettings;

  <template>
    {{#if this.siteSettings.mlm_daily_summary_enabled}}
      <div class="control-group mlm-daily-summary">
        <label class="control-label">{{i18n "mlm_daily_summary.daily"}}</label>
        <PreferenceCheckbox
          @labelKey="mlm_daily_summary.preference_label"
          @checked={{@outletArgs.model.custom_fields.user_mlm_daily_summary_enabled}}
        />
        <div class="instructions">
          {{i18n "mlm_daily_summary.instructions"}}
        </div>
      </div>
    {{/if}}
  </template>
}
