require_relative 'marvel_api_service.rb'

class MarvelChallenge
	MAGIC_WORDS = ['gamma', 'radioactive'].freeze

	def initialize(first_character, second_character, seed)
		@first_character = first_character
		@second_character = second_character
		@seed = seed.to_i - 1
	end

	def play
		words = get_description_seed_words
		choose_winner(words)
	end

	private

	def get_character_json
		api_responses = []
		[@first_character, @second_character].each do |character|
			api_responses << MarvelApiService.new(character).call
		end
		check_responses(api_responses)
		api_responses
	end

	def check_responses(responses)
		responses.each do |response|
			if response['data']['total'] < 1
				puts "We could not find one or more of your characters. Please double check your hero names and try again."
				exit
			elsif response['code'] != 200
				puts "There was a problem with the Marvel Server, please try again later."
				exit
			end
		end
	end

	def parse_description
		descriptions = []
		get_character_json.each do |response|
			descriptions << response["data"]["results"].first["description"]
		end
		descriptions
	end

	def get_description_seed_words
		first_player_word = parse_description.first.split(" ")[@seed].downcase
		second_player_word = parse_description.last.split(" ")[@seed].downcase
		[first_player_word, second_player_word]
	end

	def choose_winner(words)
		case
		when (words & MAGIC_WORDS).any?
		  select_special_word_winner(words)
		when words.first.length > words.last.length
		  puts "The description words were #{words}. The winner is player one #{@first_character}"
		when  words.first.length < words.last.length
		  puts "The description words were #{words}. The winner is player two #{@second_character}"
		when words.first.length == words.last.length
		  puts "The description words were #{words}. It's a tie!"
		else
		  puts "It seems like there might be a bit of an issue, try playing again."
		end
	end

	def select_special_word_winner(words)
		if MAGIC_WORDS.include?(words.first) && MAGIC_WORDS.include?(words.last)
			puts "*** Both players have magic words: #{words}! It is a tie?! ***"
		elsif MAGIC_WORDS.include?(words.first)
			puts "*** Magic Word #{words.first} found! Winner is #{@first_character}! ***"
		elsif MAGIC_WORDS.include?(words.last)
			puts "*** Magic Word #{words.last} found! Winner is #{@second_character}! ***"
		end
	end
end
