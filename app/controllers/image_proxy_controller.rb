# frozen_string_literal: true

class ImageProxyController < ApplicationController
  def image
    status, headers, body = retro_meet_client.image(path: request.path)
    render body:, content_type: headers["content-type"], status:
  end
end
