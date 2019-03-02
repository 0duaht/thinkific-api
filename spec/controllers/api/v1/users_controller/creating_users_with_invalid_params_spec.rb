require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'Creating Users' do
    before do
      allow(EmailAddress).to receive(:valid?) { true }
      request.content_type = 'application/vnd.api+json'
    end

    context 'when invalid params are sent' do
      describe 'emails' do
        it 'fails when duplicate email is used' do

          user = create(:user)
          post :create, body: {
            data: {
              attributes: {
                email: user.email,
                password: Faker::Internet.password
              }
            }
          }.to_json

          expect(response).to have_http_status(400)
        end

        it 'fails when an invalid email is used' do
          allow(EmailAddress).to receive(:valid?) { false }

          post :create, body: {
            data: {
              attributes: {
                email: Faker::Internet.email,
                password: Faker::Internet.password
              }
            }
          }.to_json

          expect(response).to have_http_status(400)
        end
      end

      describe 'passwords' do
        it "fails when password isn't sent in attributes" do
          post :create, body: {
            data: {
              attributes: {
                email: Faker::Internet.email
              }
            }
          }.to_json

          expect(response).to have_http_status(400)
        end

        it 'fails when password sent is blank' do
          post :create, body: {
            data: {
              attributes: {
                email: Faker::Internet.email,
                password: ''
              }
            }
          }.to_json

          expect(response).to have_http_status(400)
        end
      end

      describe 'identifiers' do
        it "fails when identifier isn't a number" do
          post :create, body: {
            data: {
              attributes: {
                email: Faker::Internet.email,
                password: Faker::Internet.password,
                identifier: Faker::Lorem.word
              }
            }
          }.to_json

          expect(response).to have_http_status(400)
        end
      end
    end
  end
end
