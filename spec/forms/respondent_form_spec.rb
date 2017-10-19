require 'rails_helper'

RSpec.describe RespondentForm, type: :form do
  work_attributes = {
    work_address_building: "2", work_address_street: "Business Lane",
    work_address_locality: "Business City", work_address_county: 'Businessbury',
    work_address_post_code: "SW1A 1AA", work_address_telephone_number: "01234000000"
  }

  attributes = {
    name: "Crappy Co. LTD",
    address_telephone_number: "01234567890", address_building: "1",
    address_street: "Business Street", address_locality: "Businesstown",
    address_county: "Businessfordshire", address_post_code: "SW1A 1AB",
    worked_at_same_address: 'false', no_acas_number: "1",
    no_acas_number_reason: "acas_has_no_jurisdiction",
    acas_early_conciliation_certificate_number: ''
  }.merge(work_attributes)

  it_behaves_like("a Form", attributes)

  let(:respondent_form) { described_class.new(Claim.new) { |f| f.assign_attributes attributes } }

  describe 'validations' do
    [:name, :address_building, :address_street, :address_locality,
     :address_post_code].each do |attr|
      it { expect(respondent_form).to validate_presence_of(attr) }
    end

    it { expect(respondent_form).to ensure_length_of(:name).is_at_most(100) }

    it { expect(respondent_form).to ensure_length_of(:address_building).is_at_most(75) }
    it { expect(respondent_form).to ensure_length_of(:address_street).is_at_most(75) }
    it { expect(respondent_form).to ensure_length_of(:address_locality).is_at_most(25) }
    it { expect(respondent_form).to ensure_length_of(:address_county).is_at_most(25) }
    it { expect(respondent_form).to ensure_length_of(:address_post_code).is_at_most(8) }
    it { expect(respondent_form).to ensure_length_of(:address_telephone_number).is_at_most(21) }

    it { expect(respondent_form).to ensure_length_of(:work_address_building).is_at_most(75) }
    it { expect(respondent_form).to ensure_length_of(:work_address_street).is_at_most(75) }
    it { expect(respondent_form).to ensure_length_of(:work_address_locality).is_at_most(25) }
    it { expect(respondent_form).to ensure_length_of(:work_address_county).is_at_most(25) }
    it { expect(respondent_form).to ensure_length_of(:work_address_post_code).is_at_most(8) }
    it { expect(respondent_form).to ensure_length_of(:work_address_telephone_number).is_at_most(21) }

    describe 'presence of work address' do
      describe "when respondent didn't work at a different address" do
        before { respondent_form.worked_at_same_address = 'true' }
        [:work_address_building, :work_address_street, :work_address_locality,
         :work_address_telephone_number, :work_address_post_code].each do |attr|
          it { expect(respondent_form).not_to validate_presence_of(attr) }
        end
      end

      describe "when respondent worked at a different address" do
        [:work_address_building, :work_address_street, :work_address_locality,
         :work_address_post_code].each do |attr|
          it { expect(respondent_form).to validate_presence_of(attr) }
        end
      end
    end

    describe 'presence of ACAS certificate number' do
      describe 'when ACAS number is indicated' do
        before { respondent_form.no_acas_number = 'false' }
        it     { expect(respondent_form).to validate_presence_of(:acas_early_conciliation_certificate_number) }

        describe 'ACAS format validation' do
          { one_char_ten_digits:  'X123456/12/12',
            two_chars_ten_digits: 'XX123456/12/12' }.each do |key, acas_value|
            it "#{key.to_s.humanize} validates correctly" do
              respondent_form.acas_early_conciliation_certificate_number = acas_value
              expect(respondent_form.valid?).to be_truthy
            end

            it "#{key.to_s.humanize} has no errors" do
              respondent_form.acas_early_conciliation_certificate_number = acas_value
              expect(respondent_form.errors).to be_empty
            end
          end

          it 'adds an error if it is invalid' do
            respondent_form.acas_early_conciliation_certificate_number = 'invalid'
            respondent_form.valid?
            expect(respondent_form.errors).not_to be_empty
          end

          it 'is invalid if acas is set to invalid' do
            respondent_form.acas_early_conciliation_certificate_number = 'invalid'
            expect(respondent_form.valid?).to be_falsey
          end
        end
      end

      describe 'when no ACAS number is indicated' do
        before { respondent_form.no_acas_number = 'true' }
        it     { expect(respondent_form).not_to validate_presence_of(:acas_early_conciliation_certificate_number) }
      end
    end

    describe 'presence of reason explaining no ACAS certificate number' do
      let(:reasons) do
        ['joint_claimant_has_acas_number', 'acas_has_no_jurisdiction', 'employer_contacted_acas', 'interim_relief']
      end

      it { expect(respondent_form).to validate_inclusion_of(:no_acas_number_reason).in_array reasons }

      describe 'when and ACAS number is given' do
        before { respondent_form.no_acas_number = 'false' }
        it     { expect(respondent_form).not_to validate_presence_of(:no_acas_number_reason) }
      end

      describe 'when and ACAS number is given' do
        before { respondent_form.no_acas_number = 'true' }
        it     { expect(respondent_form).to validate_presence_of(:no_acas_number_reason) }
      end
    end

    it 'clears acas number when selecting no acas number' do
      respondent_form.acas_early_conciliation_certificate_number = 'acas'
      respondent_form.no_acas_number = 'true'
      respondent_form.valid?

      expect(respondent_form.acas_early_conciliation_certificate_number).to be nil
    end

    context 'when worked at same address' do
      before do
        respondent_form.assign_attributes work_attributes.merge worked_at_same_address: 'true'
        respondent_form.valid?
      end

      work_attributes.each_key do |attr|
        it "clears #{attr} field" do
          expect(respondent_form.attributes[attr]).to be nil
        end
      end
    end
  end

  describe '#worked_at_same_address?' do
    it 'true when "true"' do
      respondent_form.worked_at_same_address = 'true'
      expect(respondent_form.worked_at_same_address?).to be true
    end

    it 'false when "false"' do
      respondent_form.worked_at_same_address = 'false'
      expect(respondent_form.worked_at_same_address?).to be false
    end
  end

  describe 'callbacks' do
    before { allow(respondent_form.target).to receive :enqueue_fee_group_reference_request }
    # rubocop:disable RSpec/AnyInstance
    # target.addresses always returns a new proxy so we have to do expect_any_instance
    it 'addresses reloaded on save' do
      expect_any_instance_of(respondent_form.target.addresses.class).to receive(:reload)
      respondent_form.save
    end
    # rubocop:enable RSpec/AnyInstance
  end

  describe 'postcode validation' do
    subject { respondent_form }

    include_examples "Postcode validation",
      attribute_prefix: 'address',
      error_message: 'Enter a valid UK postcode. If the respondent lives abroad, enter a SW55 9QT'

    include_examples "Postcode validation",
      attribute_prefix: 'work_address',
      error_message: 'Enter a valid UK postcode. If you live abroad enter SW55 9QT'
  end
end
