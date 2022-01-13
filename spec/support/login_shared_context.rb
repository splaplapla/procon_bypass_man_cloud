RSpec.shared_context 'login_with_admin_user' do
  let(:admin_user) { FactoryBot.create(:user, :has_admin_permission) }

  before(:each) do
    login_user(admin_user)
  end
end

RSpec.shared_context 'login_with_user' do
  let(:user) { FactoryBot.create(:user) }

  before(:each) do
    login_user(user)
  end
end
