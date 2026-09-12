import { apiInitializer } from "discourse/lib/api";
import CommunityFooter from "../components/community-footer";
import CommunityTagline from "../components/community-tagline";

/**
 * The theme's entire JavaScript surface.
 *
 * Everything else in this theme is CSS. There is no DOM manipulation, no
 * observers, no polling, and no override of core behaviour anywhere.
 *
 * Both rendered components produce no markup at all unless an administrator
 * has filled in the corresponding setting, so the default install ships zero
 * extra elements.
 */
export default apiInitializer((api) => {
  // --- Community identity -------------------------------------------------
  //
  // Above the topic list on the homepage. The component checks the route
  // itself, so the outlet choice stays broad and the logic stays in one
  // place.
  api.renderInOutlet("discovery-above", CommunityTagline);

  // Site footer, beneath core's own footer content.
  api.renderInOutlet("below-footer", CommunityFooter);

  // --- Icons --------------------------------------------------------------
  //
  // Icon *appearance* is handled in stylesheets/components/_icons.scss. This
  // section only changes icon *choices*, and only where a clearer supported
  // alternative genuinely exists.
  //
  // Deliberately minimal. Two rules governed the review:
  //
  //   1. Only semantic hooks are touched — named value transformers, and
  //      Discourse's own semantic icon aliases (`d-*`, `notification.*`,
  //      `topic.*`). Calling `replaceIcon()` on a raw Font Awesome name such
  //      as "layer-group" would silently retarget every unrelated use of
  //      that glyph across core, plugins and the admin UI.
  //
  //   2. Sidebar link icons (Latest, New, Unread, Bookmarks, Messages) are
  //      left alone on purpose. They come from `defaultPrefixValue` getters
  //      that administrators can already override per-section in site
  //      settings, and core's choices there are already semantically clear.
  //      Overriding them from a theme would take that control away.

  // "New Topic" is the primary call to action on every list page. `plus`
  // states the action; the default `far-pen-to-square` describes the tool.
  // For a button that already carries a text label, the action reads faster
  // and holds up better at small sizes.
  api.registerValueTransformer("create-topic-icon", () => "plus");
});
