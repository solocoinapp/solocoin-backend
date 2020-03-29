class Api::V1::SessionsController < Api::BaseController
  def start
    if current_user.has_active_session?
      current_user.active_session.end_session
    end

    @session = Session.new(create_params)
    @session.save!

    render json: @session, status: :created
  end

  def end
    if current_user.has_active_session?
      @session = current_user.active_session
      @session.update!(end_time: Time.zone.now, status: 1)
      render json: @session, status: :ok
    else
      render_error(422, t('general.session_not_found'))
    end
  end

  private

  def session_params
    params.require(:session).permit(:type)
  end

  def create_params
    type = session_params[:type]
    { session_type: type }.merge(user: current_user, status: 0, start_time: Time.zone.now)
  end
end
