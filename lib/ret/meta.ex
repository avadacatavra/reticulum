defmodule Ret.Meta do
  # Evaluate at build time
  @version Mix.Project.config()[:version]

  def get_meta(include_repo: false), do: base_meta()
  def get_meta(include_repo: true), do: base_meta() |> Map.merge(repo_meta())

  defp base_meta do
    %{
      version: @version,
      phx_host: module_config(:phx_host) || :net_adm.localhost() |> :net_adm.dns_hostname() |> elem(1) |> to_string,
      phx_port: Application.get_env(:ret, RetWeb.Endpoint)[:https][:port] |> to_string,
      pool: Application.get_env(:ret, Ret)[:pool]
    }
  end

  defp repo_meta do
    %{
      repo: %{
        accounts: %{
          any: Ret.Account.has_accounts?(),
          admin: Ret.Account.has_admin_accounts?()
        },
        avatar_listings: %{
          any: Ret.AvatarListing.has_any_in_filter?(nil),
          default: Ret.AvatarListing.has_any_in_filter?("default"),
          base: Ret.AvatarListing.has_any_in_filter?("base"),
          featured: Ret.AvatarListing.has_any_in_filter?("featured")
        },
        scene_listings: %{
          any: Ret.SceneListing.has_any_in_filter?(nil),
          default: Ret.SceneListing.has_any_in_filter?("default"),
          featured: Ret.SceneListing.has_any_in_filter?("featured")
        }
      }
    }
  end

  defp module_config(key) do
    Application.get_env(:ret, __MODULE__)[key]
  end
end
