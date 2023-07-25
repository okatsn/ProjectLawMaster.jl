module ProjectLawMaster
include("dirs.jl")

using ZipFile, JSON, DataFrames
include("filesummary.jl")
export FileSummary
export FindingMingFa
export FromWhere
include("expr.jl")

end # module ProjectLawMaster
