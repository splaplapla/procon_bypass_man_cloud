RSpec.shared_context 'login_with_admin_user' do
  let(:admin_user) { FactoryBot.create(:user, :is_admin) }

  before(:each) do
    login_user(admin_user)
  end
end
