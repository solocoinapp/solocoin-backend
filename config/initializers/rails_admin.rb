# frozen_string_literal: true

RailsAdmin.config do |config|
  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == CancanCan ==
  config.authorize_with :cancancan, ::AdminAbility

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory

    new do
      controller do
        proc do
          if request.get? # NEW

            @object = @abstract_model.new
            @authorization_adapter && @authorization_adapter.attributes_for(:new, @abstract_model).each do |name, value|
              @object.send("#{name}=", value)
            end
            if object_params = params[@abstract_model.to_param]
              @object.set_attributes(@object.attributes.merge(object_params))
            end
            respond_to do |format|
              format.html { render @action.template_name }
              format.js   { render @action.template_name, layout: false }
            end

          elsif request.post? # CREATE

            @modified_assoc = []
            @object = @abstract_model.new
            # satisfy_strong_params!
            sanitize_params_for!(request.xhr? ? :modal : :create)

            @object.set_attributes(params[@abstract_model.param_key])
            @authorization_adapter && @authorization_adapter.attributes_for(:create, @abstract_model).each do |name, value|
              @object.send("#{name}=", value)
            end

            # customization
            if @object.class == RewardsSponsor
              # do whatever you want
            end

            # customization
            if @object.class == CoinCode
              # do whatever you want
            end

            if @object.save
              @auditing_adapter && @auditing_adapter.create_object(@object, @abstract_model, _current_user)
              respond_to do |format|
                format.html { redirect_to_on_success }
                format.js   { render json: {id: @object.id.to_s, label: @model_config.with(object: @object).object_label} }
              end
            else
              handle_save_error
            end
          end
        end
      end
    end

    export
    bulk_delete
    show
    edit
    delete
    show_in_app

  end
end
