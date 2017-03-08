%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "src/", "web/", "apps/"],
        excluded: []
      },
      checks: [
        {Credo.Check.Warning.IoInspect, false},
        {Credo.Check.Readability.MaxLineLength, priority: :low, max_length: 120},
        {Credo.Check.Readability.ModuleDoc, false},
        {Credo.Check.Readability.Specs, false},
        {Credo.Check.Refactor.PipeChainStart, false},
      ]
    }
  ]
}