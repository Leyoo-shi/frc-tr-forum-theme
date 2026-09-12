import { apiInitializer } from "discourse/lib/api";
import CommunityFooter from "../components/community-footer";
import CommunityTagline from "../components/community-tagline";

/**
 * The theme's entire JavaScript surface.
 *
 * Everything else in this theme is CSS. These two components exist only
 * because they render text that has no native Discourse element to style —
 * there is no DOM manipulation, no observers, no polling, and no override of
 * core behaviour anywhere in the theme.
 *
 * Both components render nothing at all unless an administrator has filled
 * in the corresponding setting, so the default install ships zero extra
 * markup.
 */
export default apiInitializer((api) => {
  // Above the topic list on the homepage. The component checks the route
  // itself, so the outlet choice stays broad and the logic stays in one
  // place.
  api.renderInOutlet("discovery-above", CommunityTagline);

  // Site footer, beneath core's own footer content.
  api.renderInOutlet("below-footer", CommunityFooter);
});
