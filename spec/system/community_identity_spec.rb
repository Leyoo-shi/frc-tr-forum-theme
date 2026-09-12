# frozen_string_literal: true

# System specs for the two elements this theme renders itself.
#
# Both are opt-in, and the most important property of each is that it renders
# *nothing* when its setting is empty — a default install of this theme must
# add no markup of its own.
#
# Run with the standard Discourse theme test tooling:
#   bundle exec rspec spec/system/community_identity_spec.rb

RSpec.describe "Community identity", type: :system do
  # `upload_theme` (not `upload_theme_component`) because about.json declares
  # this as a full theme; the component helper would raise NotAComponentThemeError.
  let!(:theme) { upload_theme }

  fab!(:topic)

  context "with the community tagline" do
    it "renders nothing by default" do
      visit "/"

      expect(page).to have_no_css(".rc-community-tagline")
    end

    it "stays hidden when the tagline text is blank, even if enabled" do
      theme.update_setting(:show_community_tagline, true)
      theme.update_setting(:community_tagline, "")
      theme.save!

      visit "/"

      expect(page).to have_no_css(".rc-community-tagline")
    end

    it "shows the tagline on the homepage once configured" do
      theme.update_setting(:show_community_tagline, true)
      theme.update_setting(:community_tagline, "Türkiye robotik topluluğu")
      theme.save!

      visit "/"

      expect(page).to have_css(
        ".rc-community-tagline",
        text: "Türkiye robotik topluluğu",
      )
    end

    it "does not show the tagline away from the homepage" do
      theme.update_setting(:show_community_tagline, true)
      theme.update_setting(:community_tagline, "Türkiye robotik topluluğu")
      theme.save!

      visit "/categories"

      expect(page).to have_no_css(".rc-community-tagline")
    end
  end

  context "with the footer attribution" do
    it "renders nothing by default" do
      visit "/"

      expect(page).to have_no_css(".rc-community-footer")
    end

    it "shows plain text when no URL is configured" do
      theme.update_setting(:footer_organization_text, "Ro6one Robotics")
      theme.save!

      visit "/"

      expect(page).to have_css(".rc-community-footer__org", text: "Ro6one Robotics")
      expect(page).to have_no_css(".rc-community-footer__link")
    end

    it "links the organisation when a http(s) URL is configured" do
      theme.update_setting(:footer_organization_text, "Ro6one Robotics")
      theme.update_setting(:footer_organization_url, "https://example.com")
      theme.save!

      visit "/"

      expect(page).to have_css(
        ".rc-community-footer__link[href='https://example.com']",
        text: "Ro6one Robotics",
      )
    end

    it "refuses to link a non-http scheme" do
      theme.update_setting(:footer_organization_text, "Ro6one Robotics")
      theme.update_setting(:footer_organization_url, "javascript:alert(1)")
      theme.save!

      visit "/"

      expect(page).to have_css(".rc-community-footer__org", text: "Ro6one Robotics")
      expect(page).to have_no_css(".rc-community-footer__link")
    end
  end
end
