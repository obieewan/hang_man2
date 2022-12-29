defmodule Hangman.Impl.Game do 


  #for defstruct: the name of the struct is the module name defstruct(
  # logical structure of what we are returning
  #we'll be able to access the type of this module as Hangman.Impl.Game.t
  @type t :: %__MODULE__{
    turns_left: integer, 
    game_state: Hangman.state,
    letters: list(String.t),
    used: MapSet.t(String.t)
  }

  defstruct(
    turns_left: 7, 
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )  

  def new_game do
    new_game(Dictionary.random_word)
  end
  
  def new_game(word) do
    %__MODULE__{
    letters: word |> String.codepoints 
    }
  end

end
