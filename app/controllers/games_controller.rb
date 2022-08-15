require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = []
    alphabet = Array('a'..'z')
    10.times do
      @letters << alphabet.sample
    end
  end
  
  def score
    # Call the API with the user input
    @user_input = params[:word_input]
    api_url = "https://wagon-dictionary.herokuapp.com/"
    request_serialized = URI.open("#{api_url}#{@user_input}").read
    @result = JSON.parse(request_serialized)

    # Evaluate result from API
    @found = @result["found"]
    @your_word = @result["word"]
    @length = @result["length"]
    @error_message = "none"
    @letters = params[:letters_array].split(" ")
    
    if @found == true
      @your_word.each_char do |char|
        if @letters.include?(char)
          @score = @length
        else
          @error_message = "You used characters from outside the grid!"
          @score = 0
          break
        end
      end
    else
      @error_message = "This is not an English word!"
      @score = 0
    end
  end
end
