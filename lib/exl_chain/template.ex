defmodule ExlChain.Template do
  def new(input_valiables, template) do
    fn params ->
      input_valiables
      |> Enum.reduce(template, fn input_valiable, template ->
        replace = Map.get(params, input_valiable)
        Regex.replace(~r/{#{input_valiable}}/, template, replace)
      end)
    end
  end
end
