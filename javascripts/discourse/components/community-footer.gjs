import Component from "@glimmer/component";
import { i18n } from "discourse-i18n";
import { settings, themePrefix } from "virtual:theme";

/**
 * A small founder attribution in the site footer.
 *
 * This is the whole of the Ro6one branding surface in the theme. It is
 * deliberately one quiet line: the community is intended to outgrow the
 * organisation that started it, and the footer is where heritage belongs.
 *
 * Both the organisation name and its link are settings, so the attribution
 * can be changed or removed entirely without touching the theme — and
 * nothing about Ro6one is hardcoded anywhere in this repository's markup.
 *
 * The connecting phrase is localised (`community_footer.founded_by`); the
 * organisation name is administrator-supplied text.
 */
export default class CommunityFooter extends Component {
  get organizationText() {
    return settings.footer_organization_text?.trim();
  }

  get organizationUrl() {
    const url = settings.footer_organization_url?.trim();

    if (!url) {
      return null;
    }

    // Only http(s) destinations are linked. This blocks `javascript:` and
    // other scheme-based injection through a setting an administrator might
    // paste in without thinking.
    try {
      const parsed = new URL(url, window.location.origin);
      return ["http:", "https:"].includes(parsed.protocol) ? url : null;
    } catch {
      return null;
    }
  }

  <template>
    {{#if this.organizationText}}
      <div class="rc-community-footer">
        <span class="rc-community-footer__label">
          {{i18n (themePrefix "community_footer.founded_by")}}
        </span>
        {{#if this.organizationUrl}}
          <a
            class="rc-community-footer__link"
            href={{this.organizationUrl}}
            rel="noopener"
          >{{this.organizationText}}</a>
        {{else}}
          <span
            class="rc-community-footer__org"
          >{{this.organizationText}}</span>
        {{/if}}
      </div>
    {{/if}}
  </template>
}
