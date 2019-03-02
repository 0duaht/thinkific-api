require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'Creating Users' do
    context 'when valid params are sent' do
      before do
        request.content_type = 'application/vnd.api+json'
        allow(EmailAddress).to receive(:valid?) { true }
      end

      describe 'with default identifier' do
        before do
          post :create, body: {
            data: {
              attributes: {
                email: Faker::Internet.email,
                password: Faker::Internet.password
              }
            }
          }.to_json
        end

        it 'creates users successfully' do
          expect(response).to have_http_status(:created)
        end

        it 'creates users successfully' do
          json_res = JSON.parse(response.body)
          expect(json_res['data']['attributes']['identifier']).to eql(0)
        end

        it 'returns an api token' do
          json_res = JSON.parse(response.body)
          expect(
            json_res['data']['attributes']['api_token'].present?
          ).to be true
        end
      end

      describe 'with identifier set' do
        it 'creates users successfully' do
          test_identifier = Faker::Number.number.to_i

          post :create, body: {
            data: {
              attributes: {
                email: Faker::Internet.email,
                password: Faker::Internet.password,
                identifier: test_identifier
              }
            }
          }.to_json

          json_res = JSON.parse(response.body)
          expect(
            json_res['data']['attributes']['identifier']
          ).to eql(test_identifier)
        end
      end
    end
  end
end
