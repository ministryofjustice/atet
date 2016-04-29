require 'rails_helper'

feature 'Claim applications', type: :feature do
  include FormMethods
  include Messages
  include PdfMethods
  include MailMatchers

  around { |example| travel_to(Date.new(2014, 9, 29)) { example.run } }

  context 'along the happy path' do
    scenario 'Hitting the start page' do
      visit '/'
      expect(page).not_to have_signout_button
      expect(page).not_to have_session_prompt
    end

    scenario 'Create a new application' do
      start_claim
      expect(page).to have_text page_number(1)
      expect(page).to have_text before_you_start_message
      expect(page).not_to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering word for save and return' do
      start_claim
      fill_in_password 'green'

      claim = Claim.last
      expect(claim.authenticate 'green').to eq(claim)

      expect(page).to have_text page_number(2)
      expect(page).to have_text claim_heading_for(:claimant)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering word and email for save and return' do
      start_claim
      fill_in_password_and_email('green',
        FormMethods::SAVE_AND_RETURN_EMAIL,
        "application_number_email_address")

      claim = Claim.last
      expect(claim.authenticate 'green').to eq(claim)

      mail = ActionMailer::Base.deliveries.last
      expect(mail).to match_pattern claim.reference

      expect(page).to have_text claim_heading_for(:claimant)
    end

    scenario 'Entering personal details' do
      start_claim
      fill_in_password
      fill_in_personal_details

      expect(page).to have_text page_number(3)
      expect(page).to have_text claim_heading_for(:additional_claimants)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering additional claimant details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_additional_claimant_details

      expect(page).to have_text page_number(4)
      expect(page).to have_text claim_heading_for(:representative)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario "Navigating between manual and CSV upload for additional claimants" do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_additional_claimant_jump_to_csv_upload

      expect(page).to have_text page_number(3)
      expect(page).to have_text claim_heading_for(:additional_claimants_upload)
      expect(page).to have_signout_button

      click_link "manually"

      expect(page).to have_text page_number(3)
      expect(page).to have_text claim_heading_for(:additional_claimants)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering additional claimant upload details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_additional_claimant_jump_to_csv_upload
      fill_in_additional_claimants_upload_details

      expect(page).to have_text page_number(4)
      expect(page).to have_text claim_heading_for(:representative)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering representative details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_additional_claimant_details
      fill_in_representative_details

      expect(page).to have_text page_number(5)
      expect(page).to have_text claim_heading_for(:respondent)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering respondent details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_additional_claimant_details
      fill_in_representative_details
      fill_in_respondent_details

      expect(page).to have_text page_number(6)
      expect(page).to have_text claim_heading_for(:additional_respondents)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering additional respondent details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_additional_claimant_details
      fill_in_representative_details
      fill_in_respondent_details
      fill_in_additional_respondent_details

      expect(page).to have_text page_number(7)
      expect(page).to have_text claim_heading_for(:employment)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering employment details' do
      start_claim
      fill_in_password
      fill_in_personal_details
      fill_in_additional_claimant_details
      fill_in_representative_details
      fill_in_respondent_details
      fill_in_additional_respondent_details
      fill_in_employment_details

      expect(page).to have_text page_number(8)
      expect(page).to have_text claim_heading_for(:claim_type)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering claim type details' do
      fill_in_pre_claim_pages
      fill_in_claim_type_details

      expect(page).to have_text page_number(9)
      expect(page).to have_text claim_heading_for(:claim_details)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering claim details' do
      fill_in_pre_claim_pages
      fill_in_claim_type_details
      fill_in_claim_details

      expect(page).to have_text page_number(10)
      expect(page).to have_text claim_heading_for(:claim_outcome)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering claim outcome details' do
      fill_in_pre_claim_pages
      fill_in_claim_type_details
      fill_in_claim_details
      fill_in_claim_outcome_details

      expect(page).to have_text page_number(11)
      expect(page).to have_text claim_heading_for(:additional_information)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering additonal information' do
      fill_in_pre_claim_pages
      fill_in_claim_type_details
      fill_in_claim_details
      fill_in_claim_outcome_details
      fill_in_addtional_information

      expect(page).to have_text page_number(12)
      expect(page).to have_text claim_heading_for(:your_fee)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Entering your fee details' do
      fill_in_pre_claim_pages
      fill_in_claim_type_details
      fill_in_claim_details
      fill_in_claim_outcome_details
      fill_in_addtional_information
      fill_in_your_fee

      expect(page).to have_text review_heading_for(:show)
      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Signout from claim review page' do
      complete_a_claim
      click_button 'Submit claim'

      expect(page).to have_signout_button
      expect(page).to have_session_prompt
    end

    scenario 'Saving the confirmation email recipients' do
      complete_a_claim seeking_remissions: true
      click_button 'Submit claim'

      expect(Claim.last.confirmation_email_recipients).
        to eq [FormMethods::CLAIMANT_EMAIL, FormMethods::REPRESENTATIVE_EMAIL]
    end

    scenario 'Deselecting email confirmation recipients before submission' do
      complete_a_claim seeking_remissions: true
      deselect_claimant_email
      deselect_representative_email
      click_button 'Submit claim'

      expect(Claim.last.confirmation_email_recipients).to be_empty
    end

    scenario 'Submitting the claim when payment is not required' do
      complete_a_claim seeking_remissions: true
      click_button 'Submit claim'

      expect(page).to have_text     "Claim submitted"
      expect(page).not_to have_text "Fee paid"
      expect(page).not_to have_text "Fee to pay"
      expect(page).to have_text     'Complete an application for help with fees'
      expect(page).not_to have_signout_button
      expect(page).not_to have_session_prompt
    end

    context 'Downloading the PDF' do
      scenario 'when the file is available' do
        complete_a_claim seeking_remissions: true
        click_button 'Submit claim'

        page_pdf_link = page.find_link('Save a copy')['href']
        expect(page_pdf_link).to eq pdf_path

        pdf_file_data = Claim.last.pdf.read
        pdf_data = pdf_to_hash(pdf_file_data)
        expected_pdf_data = YAML.load(File.read('spec/support/et1_pdf_example.yml'))
        expect(pdf_data).to eq expected_pdf_data
      end

      scenario 'when the file is unavailable' do
        complete_a_claim seeking_remissions: true
        click_button 'Submit claim'

        # spoof file not being present yet by removing it -
        # in production this may happen as the jobs are ran
        # asynchronously.
        remove_pdf_from_claim
        click_link 'Save a copy'

        expect(current_path).to eq pdf_path
        expect(page).to have_text "Processing a copy of your claim"
        expect(page).not_to have_signout_button
        expect(page).not_to have_session_prompt
      end
    end

    context 'Viewing the confirmation page' do
      scenario 'with a single claimant when seeking remission' do
        complete_a_claim seeking_remissions: true
        click_button 'Submit claim', exact: true

        expect(page).to have_text 'Complete an application for help with fees'
        expect(page).not_to have_text 'You now need to pay the issue fee'
      end

      scenario 'with a single claimant when not seeking remission' do
        complete_a_claim seeking_remissions: false
        click_button 'Submit claim and proceed to payment'

        expect(page).not_to have_text 'Apply for fee remission'
        expect(page).to have_text "When you've paid the issue fee, the local tribunal office will review your claim"
      end

      scenario 'as part of a group claim with no remission' do
        complete_a_claim additional_claimants: true, seeking_remissions: 0
        click_button 'Submit claim and proceed to payment'

        expect(page).not_to have_text 'Apply for fee remission'
        expect(page).to have_text "When you've paid the issue fee, the local tribunal office will review your claim"
      end

      scenario 'as part of a group claim with partial remission' do
        complete_a_claim additional_claimants: true, seeking_remissions: 1
        click_button 'Submit claim and proceed to payment'

        expect(page).not_to have_text 'Apply for fee remission'
        expect(page).to have_text "When you've paid the issue fee, the local tribunal office will review your claim"
      end

      scenario 'as part of a group with full remission' do
        complete_a_claim additional_claimants: true, seeking_remissions: 2
        click_button 'Submit claim', exact: true

        expect(page).to have_text 'Complete an application for help with fees'
        expect(page).not_to have_text 'You now need to pay the issue fee'
      end
    end
  end
end
