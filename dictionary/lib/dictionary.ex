defmodule Dictionary do

  #not gonna delegate to the implementation anymore but to runtime
  # 
  alias Dictionary.Runtime.Server

  #got rid of start link function because this is handled now by the runtime
  #
  #random_word no longer takes server parameters now it returns a string
  @spec random_word() :: String.t
  defdelegate random_word(), to: Server
  


end
