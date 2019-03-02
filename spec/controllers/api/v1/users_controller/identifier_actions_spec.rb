require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'Interacting with Identifiers' do
    context 'unauthenticated requests' do
      it 'requires authentication for current' do
        get :next
        expect(response).to have_http_status(:unauthorized)
      end

      it 'requires authentication for next' do
        get :current, params: { api_token: Faker::Lorem.word }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'requires authentication for update' do
        put :update
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'authenticated users' do
      it 'reads the current identifier successfully' do
        identifier = Faker::Number.number.to_i
        user = create(:user, identifier: identifier)

        get :current, params: { api_token: user.api_token }

        expect(response).to have_http_status(:successful)
        json_res = JSON.parse(response.body)
        expect(json_res['data']['attributes']['identifier']).to eql(identifier)
      end

      it 'increments the identifier by calling next' do
        identifier = Faker::Number.number.to_i
        user = create(:user, identifier: identifier)

        get :next, params: { api_token: user.api_token }

        expect(response).to have_http_status(:successful)
        json_res = JSON.parse(response.body)
        expect(json_res['data']['attributes']['identifier']).to eql(
          identifier + 1
        )
        expect(user.reload.identifier).to eql(identifier + 1)
      end

      it 'sets the identifier by calling update' do
        identifier = Faker::Number.number.to_i
        user = create(:user)

        put :update, params: {
          data: { attributes: { identifier: identifier } },
          api_token: user.api_token
        }

        expect(response).to have_http_status(:successful)
        json_res = JSON.parse(response.body)
        expect(json_res['data']['attributes']['identifier']).to eql(identifier)
        expect(user.reload.identifier).to eql(identifier)
      end
    end
  end
end
