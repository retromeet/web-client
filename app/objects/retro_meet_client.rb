# frozen_string_literal: true

require "net/http/post/multipart"

# This client is designed to connect to retromeet core.
# It can be used statictly for actions unrelated to users, but then it needs to be instantiated for other operations.
class RetroMeetClient
  RetroMeetError = Class.new(StandardError)
  UnauthorizedError = Class.new(RetroMeetError)
  BadPasswordError = Class.new(UnauthorizedError)
  BadLoginError = Class.new(UnauthorizedError)
  UnprocessableRequestError = Class.new(RetroMeetError)
  UnknownError = Class.new(RetroMeetError)
  LoginAlreadyTakenError = Class.new(RetroMeetError)

  def initialize(authorization_header)
    @authorization_header = authorization_header
  end

  # (renatolond, 2024-09-17) Look into a better way to call those instance methods without a .send

  # @return (see .client)
  def client = self.class.send(:client)

  # @return (see .base_headers)
  def base_headers
    @base_headers ||= self.class.send(:base_headers).merge(authorization: @authorization_header)
  end

  # Calls the basic profile info endpoint in retromeet-core and returns the response as a ruby object
  #
  # @raise [UnauthorizedError] If it has a bad login
  # @raise [UnknownError] If an unknown error happens
  # @return [BasicProfileInfo]
  def basic_profile_info
    return nil if @authorization_header.blank?

    Sync do
      response = client.get("/api/profile/info", headers: base_headers)
      case response.status
      when 200
        response_body = JSON.parse(response.read, symbolize_names: true)
        BasicProfileInfo.new(**response_body.slice(*BasicProfileInfo.members))
      when 401
        raise UnauthorizedError, "Not logged in"
      else
        raise UnknownError, "An unknown error happened while calling retromeet-core"
      end
    ensure
      response&.close
    end
  end

  # Calls the profile info endpoint in retromeet-core and returns the response as a ruby object
  #
  # @raise [UnauthorizedError] If it has a bad login
  # @raise [UnknownError] If an unknown error happens
  # @return [ProfileInfo]
  def profile_info
    return nil if @authorization_header.blank?

    Sync do
      response = client.get("/api/profile/complete", headers: base_headers)
      case response.status
      when 200
        # @type [Hash{Symbol=>Object}]
        response_body = JSON.parse(response.read, symbolize_names: true)
        ProfileInfo.new(**response_body.slice(*ProfileInfo.members))
      when 401
        raise UnauthorizedError, "Not logged in"
      else
        raise UnknownError, "An unknown error happened while calling retromeet-core"
      end
    ensure
      response&.close
    end
  end

  # Calls the profile info endpoint in retromeet-core and returns the response as a ruby object
  #
  # @raise [UnauthorizedError] If it has a bad login
  # @raise [UnknownError] If an unknown error happens
  # @return [ProfileInfo]
  def other_profile_info(id:)
    return nil if @authorization_header.blank?

    Sync do
      response = client.get("/api/profile/#{id}/complete", headers: base_headers)
      case response.status
      when 200
        # @type [Hash{Symbol=>Object}]
        response_body = JSON.parse(response.read, symbolize_names: true)
        OtherProfileInfo.new(**response_body.slice(*OtherProfileInfo.members))
      when 401
        raise UnauthorizedError, "Not logged in"
      when 404
        raise NotFound, "Profile not found or does not exist"
      else
        raise UnknownError, "An unknown error happened while calling retromeet-core"
      end
    ensure
      response&.close
    end
  end

  # Calls the update profile info endpoint in retromeet-core and returns the response as a ruby object
  # @param params [Hash] A hash containing the params to be passed on to core. Will be modified!
  # @return [TrueClass] If the request is sucessfull
  def update_profile_info(params)
    return nil if @authorization_header.blank?

    params.transform_values! do |v|
      if v.blank?
        nil
      else
        v
      end
    end
    params[:languages]&.delete("")
    params[:genders]&.delete("")
    params[:orientations]&.delete("")

    body = params.to_json
    Sync do
      response = client.post("/api/profile/complete", headers: base_headers, body:)
      case response.status
      when 200
        true
      when 400
        pp response.read
        # TODO: Treat bad requests
        raise UnknownError
      when 401
        raise UnauthorizedError, "Not logged in"
      when 422
        raise UnknownError
      else
        raise UnknownError, "An unknown error happened while calling retromeet-core"
      end
    ensure
      response&.close
    end
  end

  # Calls the profile info endpoint in retromeet-core and returns the response as a ruby object
  #
  # @raise [UnauthorizedError] If it has a bad login
  # @raise [UnknownError] If an unknown error happens
  # @return [ProfileInfo]
  def location_search(query:)
    return nil if @authorization_header.blank?

    body = { query: }.to_json
    Sync do
      response = client.post("/api/search/address", headers: base_headers, body:)
      case response.status
      when 200
        response_body = JSON.parse(response.read, symbolize_names: true)
        response_body.map! do |result|
          LocationResult.new(**result.slice(*LocationResult.members))
        end
      else
        raise UnknownError, "An unknown error happened while calling retromeet-core"
      end
    ensure
      response&.close
    end
  end

  # Calls the update profile location endpoint in retromeet-core and returns the response as a ruby object
  # @param location [String] A location to be used as the current profile location
  # @param osm_id [Integer] The OSM id to be matched to the location
  # @return [TrueClass] If the request is sucessfull
  def update_profile_location(location:, osm_id:)
    return nil if @authorization_header.blank?

    body = { location:, osm_id: }.to_json
    Sync do
      response = client.post("/api/profile/location", headers: base_headers, body:)
      case response.status
      when 200
        true
      when 400
        pp response.read
        # TODO: Treat bad requests
        raise UnknownError
      when 401
        raise UnauthorizedError, "Not logged in"
      when 422
        error = JSON.parse(response.read, symbolize_names: true)
        raise UnprocessableRequestError, error[:detail]
      else
        raise UnknownError, "An unknown error happened while calling retromeet-core"
      end
    ensure
      response&.close
    end
  end

  # Calls the profile info endpoint in retromeet-core and returns the response as a ruby object
  #
  # @raise [UnauthorizedError] If it has a bad login
  # @raise [UnknownError] If an unknown error happens
  # @return [Array<OtherProfileInfo>]
  def nearby
    return nil if @authorization_header.blank?

    Sync do
      response = client.get("/api/listing", headers: base_headers)
      case response.status
      when 200
        response_body = JSON.parse(response.read, symbolize_names: true)
        response_body[:profiles].map! do |result|
          OtherProfileInfo.new(**result.slice(*OtherProfileInfo.members))
        end
      else
        raise UnknownError, "An unknown error happened while calling retromeet-core"
      end
    ensure
      response&.close
    end
  end

  # @param conversation_id (see #send_message)
  # @return [Conversation]
  def find_conversation(conversation_id:)
    return nil if @authorization_header.blank?

    Sync do
      response = client.get("/api/conversations/#{conversation_id}", headers: base_headers)
      case response.status
      when 200
        response_body = JSON.parse(response.read, symbolize_names: true)
        Conversation.new(**response_body.slice(*Conversation.members))
      else
        raise UnknownError, "An unknown error happened while calling retromeet-core"
      end
    ensure
      response&.close
    end
  end

  # @param conversation_id (see #send_message)
  # @return [void]
  def conversation_viewed(conversation_id:)
    return nil if @authorization_header.blank?

    Sync do
      response = client.put("/api/conversations/#{conversation_id}/viewed", headers: base_headers)
      case response.status
      when 204
        true
      else
        raise UnknownError, "An unknown error happened while calling retromeet-core"
      end
    ensure
      response&.close
    end
  end

  # @return [Array<Conversation>]
  def find_conversations
    return nil if @authorization_header.blank?

    Sync do
      response = client.get("/api/conversations", headers: base_headers)
      case response.status
      when 200
        response_body = JSON.parse(response.read, symbolize_names: true)
        response_body[:conversations].map! do |conversation|
          Conversation.new(**conversation.slice(*Conversation.members))
        end
      else
        raise UnknownError, "An unknown error happened while calling retromeet-core"
      end
    ensure
      response&.close
    end
  end

  # @param other_profile_id [String] a uuid of the other profile in the conversation
  # @return [String] The uuid of the created conversation (or of an existing one)
  def create_conversation(other_profile_id:)
    return nil if @authorization_header.blank?

    body = { other_profile_id: }.to_json
    Sync do
      response = client.post("/api/conversations", headers: base_headers, body:)
      case response.status
      when 201
        JSON.parse(response.read, symbolize_names: true)
      else
        raise UnknownError, "An unknown error happened while calling retromeet-core"
      end
    ensure
      response&.close
    end
  end

  # @param conversation_id [String] a uuid for the conversation you want to send a message to
  # @param content [String] The content of the message
  # @return [Hash] Will return the message if the insert was sucessfull
  def send_message(conversation_id:, content:)
    return nil if @authorization_header.blank?

    body = { content: }.to_json
    Sync do
      response = client.post("/api/conversations/#{conversation_id}/messages", headers: base_headers, body:)
      case response.status
      when 201
        JSON.parse(response.read, symbolize_names: true)
      else
        raise UnknownError, "An unknown error happened while calling retromeet-core"
      end
    ensure
      response&.close
    end
  end

  # Calls the profile info endpoint in retromeet-core and returns the response as a ruby object
  #
  # @param conversation_id (see #send_message)
  # @param min_id [Integer, nil] if it's not nil, will only return messages with ids bigger than this. Good to get new messages
  # @param max_id [Integer, nil] if it's not nil, will only return messages with ids smaller than this. Good to paginate results
  # @raise [UnauthorizedError] If it has a bad login
  # @raise [UnknownError] If an unknown error happens
  # @return [Array<OtherProfileInfo>]
  def find_messages(conversation_id:, min_id: nil, max_id: nil)
    return nil if @authorization_header.blank?

    params = {}
    params[:min_id] = min_id if min_id
    params[:max_id] = max_id if max_id

    query_params = params.map { |k, v| "#{k}=#{v}" }.join("&")

    Sync do
      response = client.get("/api/conversations/#{conversation_id}/messages?#{query_params}", headers: base_headers)
      case response.status
      when 200
        response_body = JSON.parse(response.read, symbolize_names: true)
        response_body[:messages].map! do |result|
          Message.new(**result.slice(*Message.members))
        end
      else
        raise UnknownError, "An unknown error happened while calling retromeet-core"
      end
    ensure
      response&.close
    end
  end

  # @param filename [String] The name of the file
  # @param io [File] The file to be uploaded
  # @param content_type [String] The content type of the original file
  # @return [void]
  def upload_profile_picture(filename:, io:, content_type:)
    return nil if @authorization_header.blank?

    form_data = {
      profile_picture: ::Multipart::Post::UploadIO.new(io, content_type, filename)
    }
    headers = {}
    multipart_post = ::Net::HTTP::Post::Multipart.new("/api/profile/picture", form_data, headers)
    headers["Content-Type"] = multipart_post["content-type"]
    Sync do
      response = client.post("/api/profile/picture", headers: base_headers.merge(headers), body: multipart_post.body_stream.read)
      case response.status
      when 204
        true
      end
    ensure
      response&.close
    end
  end

  # This method is only used if the core is storing pictures locally
  # It basically proxies the images from the core to the application
  # @param path [String] The path to the image
  # @return [List<Integer,Hash,String>] Status, headers and body
  def image(path:)
    return nil if @authorization_header.blank?

    status = headers = body = nil
    Sync do
      response = client.get("/api#{path}", headers: base_headers)
      status = response.status
      headers = response.headers
      body = response.read
    ensure
      response&.close
    end
    pp headers
    return status, headers, body
  end

  # Logs out from retromeet-core
  # @raise [UnknownError] If an unknown error happens
  # @return [void]
  def sign_out
    return nil if @authorization_header.blank?

    Sync do
      response = client.post("/logout", headers: base_headers)
      case response.status
      when 200
        @authorization_header = nil
      else
        raise UnknownError, "An unknown error happened while calling retromeet-core"
      end
    end
  end

  class << self
    # Tries to create an account in retromeet-core and converts any http errors into Ruby exceptions
    # @param login (see .login)
    # @param password (see .login)
    # @param birth_date [Date,String] The birth date of the user
    # @raise [UnknownError] If an unknown error happens
    # @return (see .login)
    def create_account(login:, password:, birth_date:)
      Sync do
        body = { login:, password:, birth_date: }.to_json
        response = client.post("/create-account", headers: base_headers, body:)
        case response.status
        when 200
          response_headers = response.headers
          response_headers["authorization"]
        when 422
          begin
            response_body = JSON.parse(response.read, symbolize_names: true)
            field_error = response_body.dig(:"field-error", 0)
            field_message = response_body.dig(:"field-error", 1)
          rescue
            field_error = "unknown field"
          end

          raise LoginAlreadyTakenError, "This login already exists" if field_error == "login" && field_message["already an account with this login"]
          raise BadLoginError, "Invalid login" if field_error == "login"
          raise BadPasswordError, "Invalid password" if field_error == "password"
          raise Date::Error, "Invalid date" if field_error == "birth_date"

          raise UnknownError
        else
          raise UnknownError, "Something went wrong, code=#{response.status}"
        end
      ensure
        response&.close
      end
    end

    # Tries to login to retromeet-core and converts any http errors into Ruby exceptions
    # @param login [String] The login to use in retromeet-core, should be an email
    # @param password [String]
    # @raise [UnauthorizedError] If one of the login fields is incorrect
    # @raise [UnknownError] If an unknown error happens
    # @return [String] If the request was sucessfull, will return the jwt authoriztion token to be used for requests
    def login(login:, password:)
      Sync do
        body = { login:, password: }.to_json
        response = client.post("/login", headers: base_headers, body:)
        case response.status
        when 200
          response_headers = response.headers
          response_headers["authorization"]
        when 401
          begin
            field_error = JSON.parse(response.read, symbolize_names: true).dig(:"field-error", 0)
          rescue
            field_error = "unknown field"
          end
          # (renatolond, 2024-09-15) in rodauth the wrong password and username are two different errors.
          # jeremyevans says an attacker can detect with a timing attack (from https://github.com/jeremyevans/rodauth/pull/45#issuecomment-338418163)
          # Look into it more and decide if we keep generic errors or not
          case field_error
          when "login"
            raise BadLoginError, "Unauthorized, login is unknown"
          when "password"
            raise BadPasswordError, "Unauthorized, password is incorrect"
          else
            raise UnauthorizedError, "Unauthorized, unknown error"
          end
        else
          raise UnknownError, "Something went wrong, code=#{response.status}"
        end
      ensure
        response&.close
      end
    end

    protected

      # Returns the retromeet-core base host to be used for requests based off the environment variables
      # @return [Async::HTTP::Endpoint]
      def retromeet_core_host = @retromeet_core_host ||= Async::HTTP::Endpoint.parse("http://localhost:3000")

      # @return [Hash] Base headers to be used for requests
      def base_headers = @base_headers ||= { "Content-Type" => "application/json", "User-Agent": RetroMeet::Version.user_agent }.freeze

      # @return [Async::HTTP::Client]
      def client = Async::HTTP::Client.new(retromeet_core_host)
  end
end
