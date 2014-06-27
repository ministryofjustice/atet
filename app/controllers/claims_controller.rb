class ClaimsController < ApplicationController
  def new
    @claim = Claim.new
    session.clear
  end

  def create
    redirect_to claim_path(Claim.create)
  end

  def update
    resource.assign_attributes send(:"#{session_manager.current_step}_params")

    if resource.save
      session_manager.perform!
      redirect_to claim_path(@claim)
    else
      render action: :show
    end
  end

  private

  helper_method def session_manager
    @session_manager ||= ClaimSessionTransitionManager.new(params: params, session: session)
  end

  helper_method def claim
    @claim ||= Claim.find_by_reference(params[:id])
  end

  helper_method def resource
    @form ||= Form.for(session_manager.current_step).new { |f| f.resource = claim }
  end

  def password_params
    params.require(:password).permit :password, :password_confirmation
  end

  def claimant_params
    params.require(:claimant).permit \
      :title, :first_name, :last_name, :gender, :date_of_birth, :telephone_number,
      :mobile_number, :contact_preference, :email_address, :has_special_needs,
      :fax_number, :special_needs, :has_representative, :address_building,
      :address_street, :address_locality, :address_county, :address_post_code
  end

  def representative_params
    params.require(:representative).permit \
      :type, :organisation_name, :name, :telephone_number,
      :mobile_number, :email_address, :dx_number, :address_building,
      :address_street, :address_locality, :address_county,
      :address_post_code
  end

  def respondent_params
    params.require(:respondent).permit \
      :organisation_name, :name, :address_telephone_number,
      :address_building, :address_street, :address_locality, :address_county,
      :address_post_code, :work_address_building,
      :work_address_street, :work_address_locality,
      :work_address_county, :work_address_post_code,
      :work_address_telephone_number, :worked_at_different_address,
      :acas_early_conciliation_certificate_number, :no_acas_number,
      :no_acas_number_reason
  end
end
