defmodule ChuckJokesWeb.PageController do
  use ChuckJokesWeb, :controller

  alias ChuckJokes.ChuckNorris

  def index(conn, _params) do

    render(conn, "index.html")
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
