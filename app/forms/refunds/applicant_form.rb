module Refunds
  class ApplicantForm < Form
    TITLES               = ['mr', 'mrs', 'miss', 'ms'].freeze
    GENDERS              = ['male', 'female', 'prefer_not_to_say'].freeze
    CONTACT_PREFERENCES  = ['email', 'post'].freeze
    EMAIL_ADDRESS_LENGTH = 100
    NAME_LENGTH          = 100

    attribute :applicant_address_building,         String
    attribute :applicant_address_street,           String
    attribute :applicant_address_locality,         String
    attribute :applicant_address_county,           String
    attribute :applicant_address_post_code,        String
    attribute :applicant_address_telephone_number, String
    attribute :is_claimant,              Boolean
    attribute :has_name_changed,         Boolean

    validates :applicant_address_building, :applicant_address_street,
      :applicant_address_post_code, presence: true

    validates :applicant_address_building,
      :applicant_address_street,
      length: { maximum: AddressAttributes::ADDRESS_LINE_LENGTH }
    validates :applicant_address_locality,
      :applicant_address_county,
      length: { maximum: AddressAttributes::LOCALITY_LENGTH }
    validates :applicant_address_telephone_number,
      length: { maximum: AddressAttributes::PHONE_NUMBER_LENGTH }

    validates :applicant_address_post_code,
      length: { maximum: AddressAttributes::POSTCODE_LENGTH }
    attribute :applicant_first_name,         String
    attribute :applicant_last_name,          String
    attribute :applicant_date_of_birth,      Date
    attribute :email_address, String
    attribute :applicant_title, String

    validates :applicant_title, :applicant_first_name, :applicant_last_name, presence: true

    validates :applicant_title, inclusion: { in: TITLES }
    validates :applicant_first_name, :applicant_last_name, length: { maximum: NAME_LENGTH }
    validates :email_address, allow_blank: true,
                              email: true,
                              length: { maximum: EMAIL_ADDRESS_LENGTH }
    validates :applicant_address_telephone_number, presence: true
    validates :applicant_date_of_birth, presence: true
    validates :has_name_changed, nil_or_empty: true

    dates :applicant_date_of_birth

    def applicant_first_name=(name)
      super name.try :strip
    end

    def applicant_last_name=(name)
      super name.try :strip
    end
  end
end