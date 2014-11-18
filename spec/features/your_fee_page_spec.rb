require 'rails_helper'

feature 'Your fee page' do
  include FormMethods

  let(:claim) { Claim.create password: 'lollolol' }

  before do
    claim.create_primary_claimant
    visit returning_user_session_path
    fill_in_return_form claim.reference, 'lollolol'
  end

  context 'single claimant' do
    scenario 'indicating remission' do
      visit claim_your_fee_path

      expect(page).to_not have_field("How many in your group want to apply for fee remission?")

      choose 'Yes'

      click_button 'Save and continue'

      expect(claim.reload.remission_claimant_count).to eq 1
    end

    scenario 'indicating no remission' do
      visit claim_your_fee_path

      expect(page).to_not have_field("How many in your group want to apply for fee remission?")

      choose 'No'

      click_button 'Save and continue'

      expect(claim.reload.remission_claimant_count).to eq 0
    end
  end

  context 'multiple claimants' do
    before { claim.secondary_claimants.create }

    scenario 'indicating remission' do
      visit claim_your_fee_path

      %w<Yes No>.each { |opt| expect(page).to_not have_button opt }

      fill_in "How many in your group want to apply for fee remission?", with: 2

      click_button 'Save and continue'

      expect(claim.reload.remission_claimant_count).to eq 2
    end

    scenario 'trying to set remission claimants > number of claimants' do
      visit claim_your_fee_path

      %w<Yes No>.each { |opt| expect(page).to_not have_button opt }

      fill_in "How many in your group want to apply for fee remission?", with: 200

      click_button 'Save and continue'

      expect(page.current_path).to eq claim_your_fee_path
      expect(page).to have_text "Please review the problems below"
      expect(claim.reload.remission_claimant_count).to eq 0
    end
  end
end