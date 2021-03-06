defmodule FromSpace.Post do
  use FromSpace.Web, :model

  alias FromSpace.Repo

  schema "posts" do
    belongs_to :admin, FromSpace.Admin
    field :title, :string
    field :url, :string
    field :preview_image, :string
    field :preview_text, :string
    field :preview_background_color, :string, default: "#000"
    field :preview_font_color, :string, default: "#fff"
    field :html, :string
    field :published, :boolean, default: false
    field :tags, {:array, :string}, default: []
    field :virtual_tags, :string, virtual: true

    timestamps
  end

  @required_fields ~w(title url preview_image preview_text preview_background_color preview_font_color html published admin_id)
  @optional_fields ~w(tags virtual_tags)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:url, on: FromSpace.Repo, downcase: true)
  end

  def all_by_creation do
    posts = from p in FromSpace.Post,
     select: p,
     order_by: [desc: p.inserted_at]
    Repo.all(posts)
  end

  def published_by_creation do
    posts = from p in FromSpace.Post,
     select: p,
     where: p.published == true,
     order_by: [desc: p.inserted_at],
     limit: 5
    Repo.all(posts)
  end

  def published_with_tag(tag) do
    posts = from p in FromSpace.Post,
      select: p,
      where: p.published == true and ^tag in p.tags,
      order_by: [desc: p.inserted_at],
      limit: 5
    Repo.all(posts)
  end
end
