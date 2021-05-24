require 'open-uri'
require 'json'

class GamesController < ApplicationController
    def new
        letter_array = ('A'..'Z').to_a
        @letters = []
        10.times {@letters << letter_array.sample(1)}
    end

    def score
        @user_word = params[:userWord].downcase
        @letter_grid = params[:letters].downcase
        user_letters = @user_word.split('')
        @result = user_letters.all? do |letter|
            @letter_grid.include?(letter) && user_letters.count(letter) <= @letter_grid.count(letter)
          end

        if @result == true 
            # call api to check if word is english
            data = URI.open("https://wagon-dictionary.herokuapp.com/#{@user_word}").read
            @json_result = JSON.parse(data)
            # Message Logic
            @found = @json_result["found"]
            if @found == true
                @message = "Congratulations! #{@user_word.upcase} is a valid English word!"
            else
                @message = "Sorry but #{user_word.upcase} does not seem to be a valid English word."
            end
        else
            @message = "Word not in the grid"      
        end
    end
end
