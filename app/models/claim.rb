class Claim < ActiveRecord::Base
  has_secure_password validations: false

  has_many :claimants
  has_many :respondents
  has_one  :representative
  has_one  :employment
  has_one  :claim_detail

  delegate :alleges_discrimination_or_unfair_dismissal?, to: :claim_detail

  def reference
    KeyObfuscator.new.obfuscate(id)
  end

  def claimant_count
    claimants.count
  end

  def remission_claimant_count
    claimants.where(applying_for_remission: true).count
  end

  def primary_claimant
    claimants.first
  end

  def primary_respondent
    respondents.first
  end

  class << self
    def find_by_reference(reference)
      find KeyObfuscator.new.unobfuscate(reference)
    end
  end
end
