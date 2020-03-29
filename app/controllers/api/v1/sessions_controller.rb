class Api::V1::SessionsController < Api::BaseController
  def start
    @session = Session.new(
      user: current_user,
      status: 0,
      start_time: Time.zone.now
    )
    @session.save!

    render json: @session, status: :created
  end

  def end
    if current_user.has_active_session?
      @session = current_user.active_session
      @session.update!(end_time: Time.zone.now, status: 1)
      render json: @session, status: :ok
    end
  end
end
