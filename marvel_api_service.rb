require 'net/http'
require 'digest'
require 'json'

class MarvelApiService
	PUBLIC_KEY=''.freeze
	# The Private Key would normally be in an ENV variable.
	# And not visible but I've shared it in this exercise for ease of use.
	PRIVATE_KEY=''.freeze
	CHARACTER_PATH='/v1/public/characters?name='.freeze
	MARVEL_API_DOMAIN='gateway.marvel.com'.freeze

	def initialize(name)
		@time = Time.now.to_i.to_s
		@name = name
	end

	def call
		begin
			JSON.parse(Net::HTTP.get(MARVEL_API_DOMAIN, url_with_parameters))
		# Normally I would rescue a more specific error, but this will do for now.
		rescue StandardError => e
			puts "It seems like there was an error with the API call: #{e.message}"
			exit
		end
	end

	private

	def generate_hash
		Digest::MD5.hexdigest(@time + PRIVATE_KEY + PUBLIC_KEY)
	end

	def url_with_parameters
		"#{CHARACTER_PATH}#{@name}&ts=#{@time}&apikey=#{PUBLIC_KEY}&hash=#{generate_hash}"
	end
end
