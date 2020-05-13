class Api::V1::ReferralsController < Api::BaseController
  def create
    if referral = Referral.create(referrer_id: current_user.id)
      render json: referral, status: :created
    else
      render_error(:unprocessable_entity, referral.errors.full_messages.to_sentence)
    end
  end

  protected

  def referrals_params
    params.require(:referrals).permit(:)
  end
end
