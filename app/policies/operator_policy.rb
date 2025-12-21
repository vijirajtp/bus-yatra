class OperatorPolicy < ApplicationPolicy

  def index?
    user.admin?
  end

  def create?
    user.admin?
  end

  def new?
    create?
  end

  def update?
    user.admin? || (record.respond_to?(:user_id) && record.user_id == user.id)
  end

  def edit?
    update?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin?
        scope.desc
      end
    end
  end
end
