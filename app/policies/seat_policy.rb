class SeatPolicy < ApplicationPolicy

  def index?
    true
  end

  def create?
    user.admin? || (record.bus.operator_id == user.operator.id)
  end

  def new?
    create?
  end

  def update?
    user.admin? || (record.bus.operator_id == user.operator.id)
  end

  def edit?
    update?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin?
        scope.all.desc
      else
        scope.joins(:bus).where(buses: { operator_id: user.operator.id }).desc
      end
    end
  end
end
