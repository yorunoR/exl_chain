defmodule ExlChain.Template do
  def new(input_variables, template) do
    fn params ->
      input_variables
      |> Enum.reduce(template, fn input_variable, template ->
        replace = Map.get(params, input_variable)
        Regex.replace(~r/{#{input_variable}}/, template, replace)
      end)
    end
  end
end
