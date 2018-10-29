require 'rails_helper'

RSpec.describe ClaimsHelper, type: :helper do
  let(:english_link) { 'https://www.gov.uk/done/employment-tribunals-make-a-claim' }
  let(:default_link) { "/#{I18n.locale}/apply/feedback" }

  describe 'feedback link' do
    context 'when English' do
      before { I18n.locale = :en }
      it { expect(helper.language_specific_feedback_url).to eql(english_link) }
    end

    context 'when Welsh' do
      before { I18n.locale = :cy }
      it { expect(helper.language_specific_feedback_url).to include(default_link) }
    end
  end

  describe 'group_claim_template_file_path' do
    context 'when English' do
      before { I18n.locale = :en }
      it { expect(helper.group_claim_template_file_path).to eql("/assets/group-claims-template.csv") }
    end

    context 'when Welsh' do
      before { I18n.locale = :cy }
      it { expect(helper.group_claim_template_file_path).to eql("/assets/group-claims-template-cy.csv") }
    end
  end
end
