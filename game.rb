#!/usr/bin/env ruby

require_relative 'marvel_challenge.rb'
class Game

	def self.initiate
	 display_instructions
	 get_inputs_and_run
	end

	def self.get_inputs_and_run
		print "* Player One * \n"
		first_character = character_input
		print "* Player Two * \n"
		second_character = character_input
		seed = seed_input
		MarvelChallenge.new(first_character, second_character, seed).play
	end

	def self.character_input
		character = ''
		until character.length >= 2
		  print 'Enter marvel character name: ' 
		  character = gets.chomp
		end
		character
	end

	def self.seed_input
		seed = 0
		until seed >= 1 && seed <= 9
		  print 'Seed between 1-9: ' 
		  seed = gets.chomp.to_i
		end
		seed
	end

	def self.display_instructions
		puts '-' * 60
		puts '| Welcome to the Marvel Api Text game.                    |'
		puts '| Please enter 2 character names and a seed between 1 - 9 |'
		puts '| The player with the longer word, or a magic word wins!  |' 
		puts '-' * 60
	end
initiate
end
