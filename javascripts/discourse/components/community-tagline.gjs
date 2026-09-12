import Component from "@glimmer/component";
import { service } from "@ember/service";
import { defaultHomepage } from "discourse/lib/utilities";
import { settings } from "virtual:theme";

/**
 * A one-line description of what this community is, shown above the topic
 * list on the homepage only.
 *
 * Rendered rather than styled-in because there is no native Discourse
 * element that carries this text. It is opt-in (`show_community_tagline`)
 * and self-suppressing when empty, so a site that does not want it pays
 * nothing — no element, no layout shift.
 *
 * The text itself is administrator-supplied via a theme setting, which is
 * why it is not localised here: the community writes it in its own language.
 * The surrounding markup carries no hardcoded strings.
 */
export default class CommunityTagline extends Component {
  @service router;

  get shouldRender() {
    if (!settings.show_community_tagline) {
      return false;
    }

    if (!settings.community_tagline?.trim()) {
      return false;
    }

    // Only on the homepage. On a category or filtered list the tagline is
    // noise — the reader already knows where they are.
    return this.router.currentRouteName === `discovery.${defaultHomepage()}`;
  }

  <template>
    {{#if this.shouldRender}}
      <p class="rc-community-tagline">{{settings.community_tagline}}</p>
    {{/if}}
  </template>
}
