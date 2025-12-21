class TripSeatPolicy < ApplicationPolicy

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
    user.admin? || (record.trip.operator_id == user.operator.id)
  end

  def edit?
    update?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin?
        scope.all.desc
      elsif user.operator?
        scope.joins(:trip).where(trips: { operator_id: user.operator.id }).desc
      else
        scope.all.desc
      end
    end
  end
end
