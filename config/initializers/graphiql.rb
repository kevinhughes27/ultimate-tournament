GraphiQL::Rails.config.headers['Authorization'] = -> (context) { "bearer #{context.cookies['jwt']}" }
