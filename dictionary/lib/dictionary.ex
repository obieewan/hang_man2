defmodule Dictionary do

  #not gonna delegate to the implementation anymore but to runtime
  # 
  alias Dictionary.Runtime.Server

  # opaque type to that the public will not know how dictionary
  # represented
  @opaque t :: Server.t

  # start will start_link in the server and the return of the agent is
  # specified @spec
  @spec start_link() :: { :ok, t }
  defdelegate start_link, to: Server # same function name in the server so alias is not needed

  #function name  should be the same in the server to avoid alias
  @spec random_word(t) :: String.t
  defdelegate random_word(word_list), to: Server
  


end
