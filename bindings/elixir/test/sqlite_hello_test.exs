defmodule SqliteHelloTest do
  use ExUnit.Case
  doctest SqliteHello

  describe "current_target/1" do
    test "aarch64 in an Apple machine with Darwin-based OS" do
      target_system = %{arch: "aarch64", vendor: "apple", os: "darwin20.3.0"}

      config = %{
        target_system: target_system,
        os_type: {:unix, :darwin}
      }

      assert {:ok, "macos-aarch64"} = SqliteHello.current_target(config)
    end

    test "x86_64 in an Apple machine with Darwin-based OS" do
      target_system = %{arch: "x86_64", vendor: "apple", os: "darwin20.3.0"}

      config = %{
        target_system: target_system,
        os_type: {:unix, :darwin}
      }

      assert {:ok, "macos-x86_64"} = SqliteHello.current_target(config)
    end

    test "x86_64 in a PC running RedHat Linux" do
      target_system = %{arch: "x86_64", vendor: "redhat", os: "linux", abi: "gnu"}

      config = %{
        target_system: target_system,
        os_type: {:unix, :linux}
      }

      assert {:ok, "linux-x86_64"} = SqliteHello.current_target(config)
    end

    test "aarch64 in a PC running Linux" do
      target_system = %{arch: "aarch64", vendor: "pc", os: "linux", abi: "gnu"}

      config = %{
        target_system: target_system,
        os_type: {:unix, :linux}
      }

      assert {:ok, "linux-aarch64"} = SqliteHello.current_target(config)
    end

    test "target not available" do
      config = %{
        target_system: %{arch: "i686", vendor: "unknown", os: "linux", abi: "gnu"},
        nif_version: "2.14",
        os_type: {:unix, :linux}
      }

      error_message =
        """
        precompiled artifact is not available for this target: \"gnu-i686-linux-unknown\".
        The available targets are:
         - linux-x86_64
         - macos-aarch64
         - macos-x86_64
        """
        |> String.trim()

      assert {:error, ^error_message} = SqliteHello.current_target(config)
    end
  end

  test "loads the hello and hola path" do
    assert String.match?(SqliteHello.loadable_path_hello0(), ~r/hellxo0/)
    assert String.match?(SqliteHello.loadable_path_hola0(), ~r/hola0/)
  end
end
