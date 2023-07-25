using OkFiles, ZipFile, ProjectLawMaster
using CairoMakie, AlgebraOfGraphics

# in windows, directly work on the zipfile on cloud:
flist = filelistall(r"\.zip\Z", raw"G:\.shortcut-targets-by-id\13nJtJKzw3hmGZIYqwBR0moSTjnXqGQ98\2023黑客松開放資料集")
@assert (splitext.(basename.(flist)) .|> last |> unique |> only) == ".zip" # test if regex works properly

f1 = flist[1]
r = ZipFile.Reader(f1);
read(r.files[4], String)

typeof(r)

r.files[1]
r.files[2]
r.files[3]
rfile = r.files[4]
splitext(rfile.name)
read(r.files[3], String)


FileSummary.(r.files)
