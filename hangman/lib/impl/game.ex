defmodule Hangman.Impl.Game do 

  alias Hangman.Type


  #for defstruct: the name of the struct is the module name defstruct(
  # logical structure of what we are returning
  #we'll be able to access the type of this module as Hangman.Impl.Game.t
  @type t :: %__MODULE__{
    turns_left: integer, 
    game_state: Type.state,
    letters: list(String.t),
    used: MapSet.t(String.t)
  }

  defstruct(
    turns_left: 7, 
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )  
  ################################
  #spec is type of the module t @type
  @spec new_game() :: t
  def new_game do
    new_game(Dictionary.random_word)
  end
  
  #this expects a word the from dictionary as string as type
  #the random word is inserted inside the struct
  @spec new_game(String.t) :: t
  def new_game(word) do
    %__MODULE__{
    letters: word |> String.codepoints 
    }
  end

  #################################
           
  
  @spec make_move(t, String.t) :: {t, Type.tally} #expected to receive guess as string
  #this function is called only if the game_state is won or lost
  #returns with the existing state
  def make_move(game = %{game_state: state}, _guess) when state in [:won, :lost] do
    game
    |> return_with_tally
    #piped to a function returns to existing state if :won or :lost
  end

  #if not :won or :lost it will accept a guess letter  
  def make_move(game, guess) do
    accept_guess(game, guess, MapSet.member?(game.used, guess)) 
    #created a function that accepts guess
    #returns true or false if the guess already use
    |> return_with_tally
  end
  ############################## 
  
  defp accept_guess(game, _guess, _already_used = true) do
    #generate a new map based on the contents of game with game state set to already used
    # returns an identical struct except the game_state to :already_used
    %{ game | game_state: :already_used}
  end

  #if the letter is not used it will accept the guess and 
  #update the letters in used map using MapSet.put
  defp accept_guess(game, guess, _already_used) do
    %{ game | used: MapSet.put(game.used, guess) }
    #modified game_state pipe to score_guess
    |> score_guess(Enum.member?(game.letters, guess)) # this gonna return true of the guessed letter is in the list
  end

  ############################## 

  
  defp score_guess(game, _good_guess = true) do
    #guessed all letters? -> :won | :good_guess
    # maybe_won function helper which tells if won or :good_guess
    new_state = maybe_won(MapSet.subset?(MapSet.new(game.letters), game.used))
    #new_state updates the game_state if :won or :good_guess
    %{ game | game_state: new_state}
  end

  #this is when the number of turns left is only 1 the game state will be lost
  defp score_guess(game = %{ turns_left: 1}, _bad_guess) do
    %{ game | game_state: :lost, turns_left: 0}
    #turns_left == 1 -> :lost | decrement :turns_left, :bad_guess
  end

  #this is thwn the number of turns left is greater than 1 then it is a bad guess
  defp score_guess(game, _bad_guess) do
    %{ game | game_state: :bad_guess, turns_left: game.turns_left - 1}
  end

  ############################## 

  #tally expecting game as map
  #this is a tally function
  #records every move
  def tally(game) do
    %{
    turns_left: game.turns_left,
    game_state:  game.game_state,
    letters: reveal_guessed_letters(game), #added reveal_guessed_letters
    used: game.used |> MapSet.to_list |> Enum.sort 
    }   
  end

  defp return_with_tally(game) do
    {game, tally(game)}
  end

  defp reveal_guessed_letters( game = %{ game_state: :lost}) do
    game.letters
  end

  defp reveal_guessed_letters(game) do 
    game.letters
    |> Enum.map(fn letter ->
      MapSet.member?(game.used, letter) |> maybe_reveal(letter)
    end)
  end

  #helper functions to show if the game is :won or a :good_guess
  defp maybe_won(true), do: :won
  defp maybe_won(_true), do: :good_guess 

  #if the letter guessed is part of the word this will show the letter
  defp maybe_reveal(true, letter), do: letter
  defp maybe_reveal(_, _letter), do: "_"

end
