require 'swagger_helper'

RSpec.describe 'users API', type: :request do
  path '/user/users' do
    get('Lista usuários') do
      tags 'Users'
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end
  end
end
