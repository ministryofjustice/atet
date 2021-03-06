module Diversities
  class IdentityForm < Form
    SEX = ["male", "female", "prefer-not-to-say"].freeze
    SEXUAL_IDENTITY = ["heterosexual-straight", "gay-lesbian", "bisexual",
                       "other", "prefer-not-to-say"].freeze
    GENDER_AT_BIRTH = ['yes_answer', 'no_answer', "prefer-not-to-say"].freeze
    GENDER = ["male-including-female-to-male-trans-men", "female-including-male-to-female-trans-women",
              "prefer-not-to-say"].freeze

    attribute :sex, :string
    attribute :sexual_identity, :string
    attribute :gender_at_birth, :string
    attribute :gender, :string
  end
end
