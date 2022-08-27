module CanChangeUserPlan
  def be_free!
    update!(plan: UserPlan::PLAN::PLAN_FREE)
  end

  def be_light!
    update!(plan: UserPlan::PLAN::PLAN_LIGHT)
  end

  def be_standard!
    update!(plan: UserPlan::PLAN::PLAN_STANDARD)
  end

  def be_pro!
    update!(plan: UserPlan::PLAN::PLAN_PRO)
  end
end

