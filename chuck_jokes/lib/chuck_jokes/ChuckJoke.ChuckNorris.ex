defmodule ChuckJokes.ChuckNorris do
  @moduledoc """
  Este modulo consume la API y gestiona la categoria en caso de que el usuario quiera una categoria especifica.
  """


  @api_url "https://api.chucknorris.io/jokes/random" #Creamos la constante de la API para manejarla mejor
  @api_url_categories "https://api.chucknorris.io/jokes/categories"

  #Esta funcion consume la API random en caso de que categoria no este definida por el usuario.
  def get_random_joke(category \\ nil) do
    url = if category, do: "#{@api_url}?category=#{category}", else: @api_url

    case HTTPoison.get(url) do #Aqui gestionamos las posibles respuestas de la API, 200 ok, otro codigo y no respuesta
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, parse_joke(body)}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Error: Received status code #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Request failed: #{reason}"}
    end
  end

  #usamos jason para parsear el JSON
  defp parse_joke(body) do
    case Jason.decode(body) do
      {:ok, %{"value" => joke}} -> joke
      _ -> "No joke found"
    end
  end

  #Extraemos las categorias
  def get_categories do
    case HTTPoison.get(@api_url_categories) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Error: Received status code #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Request failed: #{reason}"}
    end
  end


end
