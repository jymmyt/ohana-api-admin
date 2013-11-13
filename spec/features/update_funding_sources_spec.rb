require "spec_helper"

feature "Update a service's funding sources" do
  background do
    login_admin
  end

  xscenario "when service doesn't have any funding sources", :vcr do
    visit_location_with_no_phone
    page.should have_no_selector(:xpath, "//input[@type='text' and @name='funding_sources[]']")
  end

  xscenario "by adding 2 new funding_sources", { :js => true, :vcr => true } do
    visit_location_with_no_phone
    add_two_funding_sources
    visit_location_with_no_phone
    delete_two_funding_sources
  end

  xscenario "with empty service area", { :js => true, :vcr => true } do
    visit_test_location
    fill_in "funding_sources[]", with: ""
    click_button "Save changes"
    visit_test_location
    page.should have_no_selector(:xpath, "//input[@type='text' and @name='funding_sources[]']")
    add_funding_source
  end

  xscenario "with invalid service area", :vcr do
    visit_test_location
    fill_in "funding_sources[]", with: "Belmont, CA"
    click_button "Save changes"
    expect(page).to have_content "At least one service area is improperly
      formatted, or is not an accepted city or county name. Please make sure
      all words are capitalized."
  end

  xscenario "with valid service area", :vcr do
    visit_test_location
    fill_in "funding_sources[]", with: "San Mateo County"
    click_button "Save changes"
    visit_test_location
    find_field('funding_sources[]').value.should eq "San Mateo County"
  end
end