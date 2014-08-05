class EmploymentPresenter < Presenter
  present :job_title

  def start_date
    date target.start_date
  end

  present :average_hours_worked_per_week

  def gross_pay
    if [target.gross_pay, target.gross_pay_period_type].all? &:present?
      "£#{target.gross_pay} #{period_type(target.gross_pay_period_type)}"
    end
  end

  def net_pay
    if [target.net_pay, target.net_pay_period_type].all? &:present?
      "£#{target.net_pay} #{period_type(target.net_pay_period_type)}"
    end
  end

  def enrolled_in_pension_scheme
    yes_no target.enrolled_in_pension_scheme
  end

  present :benefit_details

  def current_situation
    t "simple_form.options.employment.current_situation.#{target.current_situation}"
  end

  def end_date
    date target.end_date
  end

  def worked_notice_period_or_paid_in_lieu
    yes_no target.worked_notice_period_or_paid_in_lieu
  end

  def notice_period_end_date
    date target.notice_period_end_date
  end

  def notice_period_pay
    if [notice_pay_period_count, notice_pay_period_type].all? &:present?
      "#{notice_pay_period_count} #{notice_pay_period_type}"
    end
  end

  def new_job
    yes_no target.new_job_start_date
  end

  def new_job_gross_pay
    if [target.new_job_gross_pay, target.new_job_gross_pay_frequency].all? &:present?
      "£#{target.new_job_gross_pay} #{period_type(target.new_job_gross_pay_frequency)}"
    end
  end

  private def period_type(period_type)
    t "claim_review.employment_pay_period_#{period_type}"
  end
end