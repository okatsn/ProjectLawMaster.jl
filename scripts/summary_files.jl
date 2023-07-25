using OkFiles, ZipFile, ProjectLawMaster
using DataFrames
using JSON

# in windows, directly work on the zipfile on cloud:
flist = filelistall(r"\.zip\Z", raw"G:\.shortcut-targets-by-id\13nJtJKzw3hmGZIYqwBR0moSTjnXqGQ98\2023黑客松開放資料集")
@assert (splitext.(basename.(flist)) .|> last |> unique |> only) == ".zip" # test if regex works properly

zip1 = flist[1]
r = ZipFile.Reader(zip1);
files = r.files
fss = FileSummary.(files)
fs1 = fss[7]

DataFrame(FindingMingFa(), fs1)
