# config/.credo.exs
%{
    configs: [
      %{
        name: "default",
        files: %{
          excluded: ["deps/", "node_modules/", "_build/", "apps/app_web/assets/node_modules/"]
        },
        checks: [

        ]
      }
    ]
  }
  
  