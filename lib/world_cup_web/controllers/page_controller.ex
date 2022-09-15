defmodule WorldCupWeb.PageController do
  use WorldCupWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
