defmodule ChuckJokesWeb.PageController do
  use ChuckJokesWeb, :controller

  alias ChuckJokes.ChuckNorris

  def home(conn, _params) do
    case ChuckNorris.get_categories() do
      {:ok, categories} when is_list(categories) ->
        case ChuckNorris.get_random_joke() do
          {:ok, joke} ->
            render(conn, :home, layout: false, categories: categories, joke: joke)

          {:error, _error_message} ->
            render(conn, :home, layout: false, categories: categories, joke: "No joke available")
        end

      {:error, _error_message} ->
        render(conn, :home, layout: false, categories: [], joke: "No joke available")
    end
  end




  def joke(conn, %{"category" => category}) do
    case ChuckNorris.get_random_joke(category) do
      {:ok, joke} ->
        json(conn, %{joke: joke})

      {:error, error_message} ->
        json(conn, %{error: error_message})
    end
  end

  def joke(conn, _params) do
    case ChuckNorris.get_random_joke() do
      {:ok, joke} ->
        json(conn, %{joke: joke})

      {:error, error_message} ->
        json(conn, %{error: error_message})
    end
  end

  def categories(conn, _params) do
    case ChuckNorris.get_categories() do
      {:ok, categories} ->
        json(conn, %{categories: categories})

      {:error, error_message} ->
        json(conn, %{error: error_message})
    end
  end
end
