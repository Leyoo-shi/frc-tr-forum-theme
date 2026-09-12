# Ro6one Community

A Discourse theme for a Turkish robotics community forum.

It is built for people who read long technical threads for hours: dense,
scannable topic lists, comfortable long-form reading, and code that is
genuinely pleasant in both light and dark mode. The visual language is
neutral and restrained, with a single crimson accent.

Founded by Ro6one Robotics, but designed to belong to the community rather
than to one team. Ro6one branding is limited to an optional one-line footer
attribution and the accent colour — both configurable, both removable,
neither hardcoded.

## Design principles

1. **Information first.** Content dominates the interface. Topic rows share
   one background and are separated by hairlines rather than being turned
   into cards, because cards cost vertical space and slow down scanning.
2. **Prefer core over overrides.** Discourse exposes a large set of `--d-*`
   custom properties for theming. Wherever one exists, this theme sets it
   instead of writing a selector. That keeps specificity low and survives
   core markup changes.
3. **Derive colour, never hardcode it.** Every colour is expressed in terms
   of Discourse's semantic palette (`--primary`, `--secondary`, `--tertiary`,
   …). The theme keeps working under a palette it does not ship.
4. **CSS unless JavaScript is genuinely required.** The theme has two small
   Glimmer components and nothing else — no DOM manipulation, no observers,
   no polling, no `MutationObserver`.
5. **Accessibility is a requirement.** WCAG AA contrast, visible focus on
   everything focusable, reduced-motion support, and no functionality that
   is reachable only by hovering.

## Installation

Admin → Appearance → Themes & components → Install → **From a Git
repository**, then paste the repository URL:

```
https://github.com/ro6one/forum-theme.git
```

It installs as a **full theme** (not a component) and has no dependencies —
no required components, no external assets, no build step, no server-side
code.

After installing, set it as the default theme and assign its colour
palettes: **Ro6one Community** for light and **Ro6one Community Dark** for
dark, under Admin → Appearance → Colors.

### Updating

Admin → Appearance → Themes → Ro6one Community → **Check for updates**.

## Theme settings

All settings are optional; the defaults are the intended design.

| Setting | Default | What it does |
| --- | --- | --- |
| `community_tagline` | *(empty)* | One line describing the community, shown above the homepage topic list. |
| `show_community_tagline` | `false` | Enables the tagline. No effect while the text is empty. |
| `footer_organization_text` | *(empty)* | Founder attribution in the footer. Empty hides it entirely. |
| `footer_organization_url` | *(empty)* | Optional link for the attribution. Only `http(s)` is linked. |
| `content_max_width` | `1280` | Width of the forum layout, in px. Drives core's `--d-max-width`. |
| `reading_max_width` | `760` | Width of post text, in px. Drives core's `--topic-body-width`. |
| `topic_list_density` | `compact` | `compact` or `comfortable` row spacing. |
| `show_topic_excerpts` | `false` | Two-line post preview in topic lists. Off by default — it roughly doubles row height. |
| `compact_category_page` | `false` | Tightens the categories page for communities with many categories. |
| `interface_corner_radius` | `6` | Corner rounding in px across the whole interface. |
| `header_translucency` | `true` | Subtle header blur. Auto-disabled on small screens and under reduced-transparency. |

There is deliberately **no** `community_name` setting: Discourse's own site
title already holds that, and a second source of truth would drift.

Settings are exposed to SCSS automatically as `$setting_name`, which is how
density, width and radius are applied without any JavaScript.

## File architecture

```
about.json              Full theme manifest + light/dark colour palettes
settings.yml            Admin-configurable settings
common/common.scss      Sole SCSS entry point; imports everything below
locales/                en.yml, tr_TR.yml — every custom string
javascripts/discourse/
  api-initializers/     renderInOutlet registration
  components/           Two .gjs components
spec/system/            RSpec system tests
stylesheets/
  abstracts/            _tokens.scss, _mixins.scss
  base/                 _root, _core-variables, _typography, _accessibility
  layout/               _header, _sidebar, _main
  pages/                _topic-list, _categories, _topic, _profile
  components/           _buttons, _forms, _tags, _badges, _menus, _modals,
                        _composer, _search, _code, _community
  utilities/            _responsive
```

### How the SCSS is wired

Discourse auto-loads `common/common.scss` and adds the theme's
`stylesheets/` directory to the Sass load path. Partials are therefore
imported relative to `stylesheets/`:

```scss
@import "abstracts/tokens";
@import "pages/topic-list";
```

`@import` is used rather than `@use` because Discourse prepends
`common/foundation/variables` and `common/foundation/mixins` to the
entrypoint, and those globals are only visible to `@import`ed partials. The
one exception is core's `lib/viewport` breakpoint module, which requires
`@use`; it is wrapped once in `abstracts/_mixins.scss` and re-exposed as
`rc-from()` / `rc-until()` / `rc-between()`.

### Two things that will bite you

**Boolean settings are strings.** Discourse emits every setting as
`$name: unquote("...")`, so a disabled boolean arrives as the unquoted
*string* `false` — which is **truthy** in Sass. `@if $some_bool` silently
always takes the enabled branch. Use the `rc-on()` helper:

```scss
@if rc-on($header_translucency) { … }
```

**Integer settings are strings too**, so Sass arithmetic on them fails. They
are only ever interpolated; where maths is needed, CSS `calc()` / `min()`
does it at runtime.

## Light and dark

The theme ships two palettes, **Ro6one Community** and **Ro6one Community
Dark**. Theme tokens adapt via the CSS `light-dark()` function, which reads
the `color-scheme` that Discourse sets on `:root` from the active palette.
There is no duplicated dark-mode block and no body-class dependency, so
user-selected palettes and automatic OS dark mode both work through native
Discourse mechanisms.

Surface elevation flips direction between schemes — in light mode a raised
surface is lighter than the page; in dark mode the page is the darkest
layer — and `light-dark()` expresses both without forking the stylesheet.

All foreground/background pairs in both palettes meet WCAG AA (≥4.5:1).

## Compatibility philosophy

This is a theme, not a plugin. It contains no Ruby, no migrations, no
backend, and modifies no core files.

It restyles native Discourse UI rather than replacing it. Anonymous and
logged-in browsing, trust levels, groups, staff/moderation UI, private
messages, notifications, drafts, bookmarks, polls, solved topics, tags,
category permissions, uploads, oneboxes, user cards, topic timelines,
flagging, post editing, mobile navigation, the sidebar, keyboard shortcuts,
search and the composer are all left to core.

Plugin-specific selectors (solved, math, poll) are written defensively: if
the plugin is absent, the selector simply never matches.

Admin routes are intentionally left close to core. Only harmless global
tokens (radius, input colours) carry over.

No category or tag name is referenced anywhere. The community can create
whatever hierarchy it needs — FRC, FTC, VEX, electronics, CAD, controls,
vision, outreach — without the theme knowing about it in advance.

## Local development

Requires Node ≥ 22 and pnpm 10.

```bash
pnpm install
```

Lint everything (stylelint, ESLint, Prettier, Glint types):

```bash
pnpm lint
```

Auto-fix what can be fixed:

```bash
pnpm lint:fix
```

Live-reload against a running Discourse instance using the official CLI:

```bash
gem install discourse_theme && discourse_theme watch .
```

Run the system tests from a Discourse checkout:

```bash
bundle exec rspec spec/system
```

## Contributing

- Keep specificity low. If core exposes a `--d-*` variable for what you want
  to change, set the variable instead of writing a selector.
- Every user-facing string must live in `locales/en.yml` and `locales/tr_TR.yml`.
  Nothing user-facing should be hardcoded in a `.gjs` file.
- Avoid `!important`. There is currently none in this theme; if you
  genuinely need one, document why in a comment next to it.
- Run `pnpm lint` before opening a pull request.
- New settings need descriptions in **both** locale files.

## License

MIT — see [LICENSE](LICENSE).
