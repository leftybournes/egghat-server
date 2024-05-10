defmodule ScrambleWeb.IngredientLiveTest do
  use ScrambleWeb.ConnCase

  import Phoenix.LiveViewTest
  import Scramble.RecipesFixtures

  @create_attrs %{amount: "120.5", measurement_unit: "some measurement_unit", name: "some name"}
  @update_attrs %{amount: "456.7", measurement_unit: "some updated measurement_unit", name: "some updated name"}
  @invalid_attrs %{amount: nil, measurement_unit: nil, name: nil}

  defp create_ingredient(_) do
    ingredient = ingredient_fixture()
    %{ingredient: ingredient}
  end

  describe "Index" do
    setup [:create_ingredient]

    test "lists all ingredients", %{conn: conn, ingredient: ingredient} do
      {:ok, _index_live, html} = live(conn, ~p"/ingredients")

      assert html =~ "Listing Ingredients"
      assert html =~ ingredient.measurement_unit
    end

    test "saves new ingredient", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/ingredients")

      assert index_live |> element("a", "New Ingredient") |> render_click() =~
               "New Ingredient"

      assert_patch(index_live, ~p"/ingredients/new")

      assert index_live
             |> form("#ingredient-form", ingredient: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#ingredient-form", ingredient: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/ingredients")

      html = render(index_live)
      assert html =~ "Ingredient created successfully"
      assert html =~ "some measurement_unit"
    end

    test "updates ingredient in listing", %{conn: conn, ingredient: ingredient} do
      {:ok, index_live, _html} = live(conn, ~p"/ingredients")

      assert index_live |> element("#ingredients-#{ingredient.id} a", "Edit") |> render_click() =~
               "Edit Ingredient"

      assert_patch(index_live, ~p"/ingredients/#{ingredient}/edit")

      assert index_live
             |> form("#ingredient-form", ingredient: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#ingredient-form", ingredient: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/ingredients")

      html = render(index_live)
      assert html =~ "Ingredient updated successfully"
      assert html =~ "some updated measurement_unit"
    end

    test "deletes ingredient in listing", %{conn: conn, ingredient: ingredient} do
      {:ok, index_live, _html} = live(conn, ~p"/ingredients")

      assert index_live |> element("#ingredients-#{ingredient.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#ingredients-#{ingredient.id}")
    end
  end

  describe "Show" do
    setup [:create_ingredient]

    test "displays ingredient", %{conn: conn, ingredient: ingredient} do
      {:ok, _show_live, html} = live(conn, ~p"/ingredients/#{ingredient}")

      assert html =~ "Show Ingredient"
      assert html =~ ingredient.measurement_unit
    end

    test "updates ingredient within modal", %{conn: conn, ingredient: ingredient} do
      {:ok, show_live, _html} = live(conn, ~p"/ingredients/#{ingredient}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Ingredient"

      assert_patch(show_live, ~p"/ingredients/#{ingredient}/show/edit")

      assert show_live
             |> form("#ingredient-form", ingredient: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#ingredient-form", ingredient: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/ingredients/#{ingredient}")

      html = render(show_live)
      assert html =~ "Ingredient updated successfully"
      assert html =~ "some updated measurement_unit"
    end
  end
end
