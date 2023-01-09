defmodule HangmanImplGameTest do
  use ExUnit.Case
  doctest Hangman

  alias Hangman.Impl.Game

  test "new game returns structure" do
    game = Game.new_game

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "new game returns correct word" do
    game = Game.new_game("combat")

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ["c", "o", "m", "b", "a", "t"]
    #checks that each element is in lower case
    assert Enum.all?(game.letters, fn codepoint -> String.match?(codepoint, ~r/^[a-z]+$/) end)
  end

  test "state doesn't change if a game is won or lost" do
    #created a loop for :won :lost
    for state <- [:won, :lost] do
    game = Game.new_game("combat")
    #:game_state change to won manually to see if the state changes after another turn or won
    game = Map.put(game, :game_state, :won)
    { new_game, _tally } = Game.make_move(game, "x")
    assert new_game == game
    end
  end

  #test to check if the guess is duplicate or already used
  test " a duplicate letter is reported" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "we record letters used" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "y")
    {game, _tally} = Game.make_move(game, "x")
    assert MapSet.equal?(game.used, MapSet.new(["x", "y"]))
  end

  test "we recognize a letter in the word" do
    game = Game.new_game("combat")
    {_game, tally} = Game.make_move(game, "m")
    assert tally.game_state == :good_guess
    {_game, tally} = Game.make_move(game, "t")
    assert tally.game_state == :good_guess
  end

  test "we recognize a letter not in the word" do
    game = Game.new_game("combat")
    {_game, tally} = Game.make_move(game, "m")
    assert tally.game_state == :good_guess
    {_game, tally} = Game.make_move(game, "x")
    assert tally.game_state == :bad_guess
    {_game, tally} = Game.make_move(game, "n")
    assert tally.game_state == :bad_guess
  end

  #test for hello word
  test "can handle a sequence of move won" do
  [
    # guess | state |turns | letters                | used
    ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
    ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
    ["e", :good_guess, 6,["_", "e", "_", "_", "_"], ["a", "e"]],
    ["x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]],
    ["l", :good_guess, 5, ["_", "e", "l", "l", "_"], ["a", "e", "l", "x"]],
    ["o", :good_guess, 5, ["_", "e", "l", "l", "o"], ["a", "e", "l", "o", "x"]],
    ["h", :won , 5, ["h", "e", "l", "l", "o"], ["a", "e", "h", "l", "o", "x"]]
  ]
  |> test_sequence_of_move()
  end
  
  test "can handle a sequence of move lost" do
  [
    # guess | state |turns | letters                | used
    ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
    ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
    ["e", :good_guess, 6,["_", "e", "_", "_", "_"], ["a", "e"]],
    ["x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]],
    ["l", :good_guess, 5, ["_", "e", "l", "l", "_"], ["a", "e", "l", "x"]],
    ["o", :good_guess, 5, ["_", "e", "l", "l", "o"], ["a", "e", "l", "o", "x"]],
    ["b", :bad_guess , 4, ["_", "e", "l", "l", "o"], ["a", "b", "e", "l", "o", "x"]],
    ["c", :bad_guess , 3, ["_", "e", "l", "l", "o"], ["a", "b", "c", "e", "l", "o", "x"]],
    ["d", :bad_guess , 2, ["_", "e", "l", "l", "o"], ["a", "b", "c", "d", "e", "l", "o", "x"]],
    ["f", :bad_guess , 1, ["_", "e", "l", "l", "o"], ["a", "b", "c", "d", "e", "f", "l", "o", "x"]],
    ["g", :lost , 0, ["_", "e", "l", "l", "o"], ["a", "b", "c", "d", "e", "f", "g", "l", "o", "x"]],
  ]
  |> test_sequence_of_move()
  end

  #script which is an array
  #in test scripts can also use mainline code 
  def test_sequence_of_move(script) do

    game = Game.new_game("hello")
    Enum.reduce(script, game, &check_one_move/2)
  end

  def check_one_move([ guess, state, turns, letters, used ], game) do
    { game, tally} = Game.make_move(game, guess)

    assert tally.game_state == state
    assert tally.turns_left == turns
    assert tally.letters == letters
    assert tally.used == used
    game
  end



end
