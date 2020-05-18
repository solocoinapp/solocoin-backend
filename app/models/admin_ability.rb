# frozen_string_literal: true

class AdminAbility
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :access, :rails_admin
      can :read, :dashboard            # dashboard access
      can :manage, :all             # allow superadmins to do anything
    elsif user.thirdparty?
      can :access, :rails_admin
      can :read, :dashboard            # dashboard access
      can :manage, RewardsSponsor, user_id: user.id
    end
  end
end
