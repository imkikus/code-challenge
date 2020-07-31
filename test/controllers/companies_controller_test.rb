require "test_helper"
require "application_system_test_case"

class CompaniesControllerTest < ApplicationSystemTestCase

  def setup
    @company = companies(:hometown_painting)
  end

  test "Index" do
    visit companies_path

    assert_text "Companies"
    assert_text "Hometown Painting"
    assert_text "Wolf Painting"
  end

  test "Show" do
    visit company_path(@company)

    assert_text @company.name
    assert_text @company.phone
    assert_text @company.email
    assert_text "City, State"
  end

  test "Update" do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: "93009")
      click_button "Update Company"
    end

    assert_text "Changes Saved"

    @company.reload
    assert_equal "Updated Test Company", @company.name
    assert_equal "93009", @company.zip_code
  end

  test "Delete" do
    visit company_path(@company)

    click_link "Delete"
    page.accept_alert
    assert_text "Company with name #{@company.name} deleted!"
  end

  test "Create company if valid email is present" do
    visit new_company_path
    within("form#new_company") do
      fill_in("company_name", with: "New Test Company")
      fill_in("company_zip_code", with: "28173")
      fill_in("company_phone", with: "5553335555")
      fill_in("company_email", with: "new_test_company@getmainstreet.com")
      click_button "Create Company"
    end
    assert_text "Saved"
    last_company = Company.last
    assert_equal "New Test Company", last_company.name
    assert_equal "28173", last_company.zip_code
  end

  test "Create company without email param" do
    visit new_company_path
    within("form#new_company") do
      fill_in("company_name", with: "Member Company")
      fill_in("company_zip_code", with: "60004")
      fill_in("company_phone", with: "5553335555")
      click_button "Create Company"
    end
    assert_text "Saved"
    last_company = Company.last
    assert_equal "Member Company", last_company.name
    assert_equal "60004", last_company.zip_code
  end

  test "with invalid email" do
    visit new_company_path
    within("form#new_company") do
      fill_in("company_name", with: "Non-member Company")
      fill_in("company_zip_code", with: "60005")
      fill_in("company_phone", with: "5553335555")
      fill_in("company_email", with: "company@kikus.com")
      click_button "Create Company"
    end
    assert_text "1 error prohibited this company from being saved"
    assert_text "Email of the company should be of <example@getmainstreet.com>"
  end

  test "Add City, State to the company from the Zipcode provided" do
    visit new_company_path
    within("form#new_company") do
      fill_in("company_name", with: "Zipped Company")
      fill_in("company_zip_code", with: "60007")
      fill_in("company_phone", with: "5553335555")
      click_button "Create Company"
    end
    assert_text "Saved"
    last_company = Company.last
    assert_equal "Zipped Company", last_company.name
    assert_equal "60007", last_company.zip_code
    assert_equal "Elk Grove Village", last_company.city
    assert_equal "Illinois", last_company.state
  end

  test "Add City, State to the company from the Zipcode provided, display the same in company details page" do
    visit edit_company_path(@company)
    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: "60009")
      click_button "Update Company"
    end
    assert_text "Changes Saved"
    visit company_path(@company)
    assert_text "#{@company.city}, #{@company.state}"
  end

  test "Invalid zipcode exceeding 5 characters" do
    visit new_company_path
    within("form#new_company") do
      fill_in("company_name", with: "Non-member Company")
      fill_in("company_zip_code", with: "600066")
      click_button "Create Company"
    end
    assert_text "2 errors prohibited this company from being saved"
    assert_text "Zip code is the wrong length (should be 5 characters)"
    assert_text "Zip code translation missing: en.error.invalid_zipcode"
  end

  test "Invalid zipcode" do
    visit new_company_path
    within("form#new_company") do
      fill_in("company_name", with: "Non-member Company")
      fill_in("company_zip_code", with: "11111")
      click_button "Create Company"
    end
    assert_text "1 error prohibited this company from being saved"
    assert_text "Zip code translation missing: en.error.invalid_zipcode"
  end
end
