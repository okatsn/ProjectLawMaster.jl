using OkFiles, ZipFile, ProjectLawMaster
using DataFrames
using JSON

# in windows, directly work on the zipfile on cloud:
flist = filelistall(r"\.zip\Z", raw"G:\.shortcut-targets-by-id\13nJtJKzw3hmGZIYqwBR0moSTjnXqGQ98\2023黑客松開放資料集")
@assert (splitext.(basename.(flist)) .|> last |> unique |> only) == ".zip" # test if regex works properly

df = DataFrame()
for zip1 in flist
    r = try
        r = ZipFile.Reader(zip1);
    catch e
        e::EOFError
        continue
    end
    files = r.files
    fss = FileSummary.(files)
    for fs in fss
        df1 = DataFrame(FindingMingFa(), fs)
        append!(df, df1; cols = :union, promote = true)
    end
end
