defmodule SkadiWeb.MovementLiveTest do
  use SkadiWeb.ConnCase

  import Phoenix.LiveViewTest
  import Skadi.FinancesFixtures

  @create_attrs %{date: "2026-07-16", source: "some source", destination: "some destination", direction: :income, notes: "some notes"}
  @update_attrs %{date: "2026-07-17", source: "some updated source", destination: "some updated destination", direction: :expense, notes: "some updated notes"}
  @invalid_attrs %{date: nil, source: nil, destination: nil, direction: nil, notes: nil}

  setup :register_and_log_in_user

  defp create_movement(%{scope: scope}) do
    movement = movement_fixture(scope)

    %{movement: movement}
  end

  describe "Index" do
    setup [:create_movement]

    test "lists all movements", %{conn: conn, movement: movement} do
      {:ok, _index_live, html} = live(conn, ~p"/movements")

      assert html =~ "Listing Movements"
      assert html =~ movement.source
    end

    test "saves new movement", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/movements")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Movement")
               |> render_click()
               |> follow_redirect(conn, ~p"/movements/new")

      assert render(form_live) =~ "New Movement"

      assert form_live
             |> form("#movement-form", movement: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#movement-form", movement: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/movements")

      html = render(index_live)
      assert html =~ "Movement created successfully"
      assert html =~ "some source"
    end

    test "updates movement in listing", %{conn: conn, movement: movement} do
      {:ok, index_live, _html} = live(conn, ~p"/movements")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#movements-#{movement.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/movements/#{movement}/edit")

      assert render(form_live) =~ "Edit Movement"

      assert form_live
             |> form("#movement-form", movement: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#movement-form", movement: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/movements")

      html = render(index_live)
      assert html =~ "Movement updated successfully"
      assert html =~ "some updated source"
    end

    test "deletes movement in listing", %{conn: conn, movement: movement} do
      {:ok, index_live, _html} = live(conn, ~p"/movements")

      assert index_live |> element("#movements-#{movement.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#movements-#{movement.id}")
    end
  end

  describe "Show" do
    setup [:create_movement]

    test "displays movement", %{conn: conn, movement: movement} do
      {:ok, _show_live, html} = live(conn, ~p"/movements/#{movement}")

      assert html =~ "Show Movement"
      assert html =~ movement.source
    end

    test "updates movement and returns to show", %{conn: conn, movement: movement} do
      {:ok, show_live, _html} = live(conn, ~p"/movements/#{movement}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/movements/#{movement}/edit?return_to=show")

      assert render(form_live) =~ "Edit Movement"

      assert form_live
             |> form("#movement-form", movement: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#movement-form", movement: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/movements/#{movement}")

      html = render(show_live)
      assert html =~ "Movement updated successfully"
      assert html =~ "some updated source"
    end
  end
end
