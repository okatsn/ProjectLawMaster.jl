using ProjectLawMaster
using Documenter

DocMeta.setdocmeta!(ProjectLawMaster, :DocTestSetup, :(using ProjectLawMaster); recursive=true)

makedocs(;
    modules=[ProjectLawMaster],
    authors="okatsn <okatsn@gmail.com> and contributors",
    repo="https://github.com/okatsn/ProjectLawMaster.jl/blob/{commit}{path}#{line}",
    sitename="ProjectLawMaster.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://okatsn.github.io/ProjectLawMaster.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/okatsn/ProjectLawMaster.jl",
    devbranch="main",
)
