module JWTUtils

  ALGORITHM = "HS256"

  module_function

  def encode(payload, secret)
    raise ArgumentError.new("Secret is not specified") if secret.blank?
    JWT.encode(payload, secret, ALGORITHM)
  end

  def decode(token, secret)
    raise ArgumentError.new("Secret is not specified") if secret.blank?

    begin
      result(JWT.decode(token, secret, true, algorithm: ALGORITHM), nil)
    rescue JWT::VerificationError
      result(nil, :verification_error)
    rescue JWT::DecodeError
      # This is basically an else-block
      # DecodeError is the superclass for all other JWT error classes

      # You can add additional exception handlers for each exception
      # To see all the available exceptions, see:
      # https://github.com/jwt/ruby-jwt/blob/ee7c24c4697ebcc050723ca1c0090a865c6788ec/lib/jwt.rb#L12

      result(nil, :decode_error)
    end
  end

  # private

  def result(decoded, error = nil)
    if error.nil?
      Result::Success.new(decoded)
    else
      Result::Error.new("JWT decoding failed", {error_code: error})
    end
  end

end
