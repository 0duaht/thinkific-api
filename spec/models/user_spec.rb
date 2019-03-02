require 'rails_helper'

RSpec.describe User, type: :model do
  it 'increments identifier appropriately' do
    user = FactoryBot.create(:user)
    expect { user.increment_identifier }.to change(user, :identifier).by 1
  end
end
