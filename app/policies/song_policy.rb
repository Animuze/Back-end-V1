class SongPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    @user.has_any_role? :Admin, :Manager
  end

  def new?
    @user.has_any_role? :Admin, :Manager
  end

  def show?
    @user.has_any_role? :Admin, :Manager
  end

  def create?
    @user.has_any_role? :Admin, :Manager
  end

  def update?
    @user.has_any_role? :Admin, :Manager
  end
  def songplay?
    @user.has_any_role? :Admin, :Manager
  end
  def edit?
    @user.has_any_role? :Admin, :Manager
  end

  def destroy?
    @user.has_any_role? :Admin, :Manager
  end
end
