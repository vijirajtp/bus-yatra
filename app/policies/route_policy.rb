class RoutePolicy < ApplicationPolicy

  def index?
    true
  end

  def create?
    user.admin? || user.operator?
  end

  def new?
    create?
  end

  def update?
    user.admin? || user.operator?
  end

  def edit?
    update?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.desc
    end
  end
end
