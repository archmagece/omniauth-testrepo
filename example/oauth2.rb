# frozen_string_literal: true

require_relative "oauth-commmon"

get_result("authorize_url")

# http://localhost:3000/auth/kakao/callback?code=GUvGjgobB9UUc0CCcJET2k48V32Fpoc63qwZYeXrkqFOsE-y2hiqEQAAAAQKPCQhAAABlGkAxh6GtS2__sNdBQ
# http://localhost:8080/auth/realms/master/broker/kakao/endpoint?code=Sx6D5QhOJWVEVIIkBEbu4p5zSXJDasc9F2Y3bBfS4_xSsBQTiJYk3wAAAAQKKiURAAABlGkP9PDo6jj-qNQmaA
# http://localhost:8080/auth/realms/master/broker/kakao/endpoint?code=2L3BjJ1ly8aHImX6nG-Em7YtSlUHcl3njzjnPi7fWLcEJdYafKEhngAAAAQKKwyoAAABlGkdND4WphHJzwXJqw
verifier = "2L3BjJ1ly8aHImX6nG-Em7YtSlUHcl3njzjnPi7fWLcEJdYafKEhngAAAAQKKwyoAAABlGkdND4WphHJzwXJqw"
token = @client.get_token({
                            client_id: @client.id,
                            grant_type: "authorization_code",
                            code: verifier,
                            redirect_uri: @redirect_uri
                          })
puts token
