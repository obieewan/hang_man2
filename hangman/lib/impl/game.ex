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

  #spec is type of the module t @type
  @spec new_game() :: t
  def new_game do
    new_game(Dictionary.random_word)
  end
  
  #this expects a word the from dictionary as string as type
  @spec new_game(String.t) :: t
  def new_game(word) do
    %__MODULE__{
    letters: word |> String.codepoints 
    }
  end

end
