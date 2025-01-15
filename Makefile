setup:
	cp .env.sample .env
	ruby -e "require 'securerandom'; puts SecureRandom.hex(32)"

start:
	ruby app.rb
	# rackup config.ru
	bundle exec rackup -p 3000
