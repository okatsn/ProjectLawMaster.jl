using OkFiles, ZipFile, ProjectLawMaster
using DataFrames, CSV
using JSON

# in windows, directly work on the zipfile on cloud:
flist = filelistall(r"\.zip\Z", raw"G:\.shortcut-targets-by-id\13nJtJKzw3hmGZIYqwBR0moSTjnXqGQ98\2023黑客松開放資料集")
@assert (splitext.(basename.(flist)) .|> last |> unique |> only) == ".zip" # test if regex works properly

# targetfile = "docs/summary_table.csv"
# df_template  = DataFrame(
#     :target => AbstractString[],
#     :target_type => Regex[],
#     :target_in => FromWhere[],
#     :uncompresssedsize => UInt64[],
#     :filename => AbstractString[],
#     :path_to_file => AbstractString[]
# )

# CSV.write(targetfile, df_template)
df = DataFrame()

@time for zip1 in flist
    r = try
        r = ZipFile.Reader(zip1);
    catch e
        e::EOFError
        continue
    end
    df0  = DataFrame()
    files = r.files
    fss = FileSummary.(files)
    for fs in fss
        df1 = DataFrame(FindingMingFa(), fs)
        append!(df0, df1; cols = :union, promote = true)
    end

    insertcols!(df0, :zipwhere => zip1)

    # CSV.write(targetfile, df0; append= true)
    append!(df, df0; cols = :union, promote = true)
end
