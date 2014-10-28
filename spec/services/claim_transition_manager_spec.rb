require "rails_helper"

RSpec.describe ClaimTransitionManager, type: :service do
  let(:subject) { described_class.new resource: resource }

  describe '.first_page' do
    it 'returns the first page in the process' do
      expect(described_class.first_page).to eq('application-number')
    end
  end

  describe '#current_page' do
    let(:resource) { ApplicationNumberForm.new }

    it 'returns the current page based on the current transition' do
      expect(subject.current_page).to eq(1)
    end
  end

  describe '.pages' do
    it 'returns an array of managed pages' do
      expect(described_class.pages).
        to eq %w<application-number claimant additional-claimants representative
          respondent employment claim-type claim-details claim-outcome
          additional-information your-fee review>
    end
  end

  describe '#total_pages' do
    let(:resource) { ClaimantForm.new }

    it 'returns the total pages (based on the number of rules)' do
      expect(subject.total_pages).to eq(11)
    end
  end

  describe '#forward' do

    context 'when resource is a ApplicationNumberForm' do
      let(:resource) { ApplicationNumberForm.new }
      its(:forward)  { is_expected.to eq('claimant') }
    end

    context 'when resource is a ClaimantForm' do
      let(:resource) { ClaimantForm.new }
      its(:forward) { is_expected.to eq('additional-claimants') }
    end

    context 'when resource is a AdditionalClaimantsForm' do
      let(:resource) { AdditionalClaimantsForm.new }
      its(:forward)  { is_expected.to eq('representative') }
    end

    context 'when resource is a RepresentativeForm' do
      let(:resource) { RepresentativeForm.new }
      its(:forward)  { is_expected.to eq('respondent') }
    end

    context 'when resource is a RespondentForm' do
      let(:resource) { RespondentForm.new }
      its(:forward) { is_expected.to eq('employment') }
    end

    context 'when resource is a EmploymentForm' do
      let(:resource) { EmploymentForm.new }
      its(:forward)  { is_expected.to eq('claim-type') }
    end

    context 'when resource is a ClaimTypeForm' do
      let(:resource) { ClaimTypeForm.new }
      its(:forward)  { is_expected.to eq('claim-details') }
    end

    context 'when resource is a ClaimDetailsForm' do
      let(:resource) { ClaimDetailsForm.new }
      its(:forward)  { is_expected.to eq('claim-outcome') }
    end

    context 'when resource is a ClaimOutcomeForm' do
      let(:resource) { ClaimOutcomeForm.new }
      its(:forward)  { is_expected.to eq('additional-information') }
    end

    context 'when resource is a AdditionalInformationForm' do
      let(:resource) { AdditionalInformationForm.new }
      its(:forward)  { is_expected.to eq('your-fee') }
    end

    context 'when resource is a YourFeeForm' do
      let(:resource) { YourFeeForm.new }
      its(:forward)  { is_expected.to eq('review') }
    end
  end
end
