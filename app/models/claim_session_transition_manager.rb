class ClaimSessionTransitionManager
  TRANSITIONS = [
    { from: nil, to: :personal },
    { from: :personal, to: :representative, if: :has_representative },
    { from: :personal, to: :employer },
    { from: :representative, to: :employer },
    { from: :employer, to: :employment, if: :was_employed },
    { from: :employer, to: :claim },
    { from: :employment, to: :claim }
  ].freeze

  def initialize(params:, session:)
    @params = params
    @session = session
  end

  def perform!
    if transition
      stack.push transition[:to]
    end
  end

  def current_step
    stack.last
  end

  def previous_step
    stack[-2]
  end

  private def stack
    @session[:step_stack] ||= []
  end

  private def transition
    TRANSITIONS.find do |t|
      next unless t[:from] == current_step

      condition = t[:if]
      condition ? @params[condition].present? : true
    end
  end
end