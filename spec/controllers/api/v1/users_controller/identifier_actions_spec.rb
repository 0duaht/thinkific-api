require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'Interacting with Identifiers' do
    before { request.content_type = 'application/vnd.api+json' }
    context 'unauthenticated requests' do
      it 'requires authentication for current' do
        get :next
        expect(response).to have_http_status(:unauthorized)
      end

      it 'requires authentication for next' do
        request.headers.merge('Authorization' => "Bearer #{Faker::Lorem.word}")
        get :current
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

        request.headers.merge('Authorization' => "Bearer #{user.api_token}")
        get :current

        expect(response).to have_http_status(:successful)
        json_res = JSON.parse(response.body)
        expect(json_res['data']['attributes']['identifier']).to eql(identifier)
      end

      it 'increments the identifier by calling next' do
        identifier = Faker::Number.number.to_i
        user = create(:user, identifier: identifier)

        request.headers.merge('Authorization' => "Bearer #{user.api_token}")
        get :next

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

        request.headers.merge('Authorization' => "Bearer #{user.api_token}")
        put :update, body: {
          data: { attributes: { identifier: identifier } }
        }.to_json

        expect(response).to have_http_status(:successful)
        json_res = JSON.parse(response.body)
        expect(json_res['data']['attributes']['identifier']).to eql(identifier)
        expect(user.reload.identifier).to eql(identifier)
      end
    end
  end
end
