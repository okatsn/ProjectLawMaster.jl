
struct FileSummary
    ext # extension
    fname # filename
    parents
end

function FileSummary(rfile::ZipFile.ReadableFile)
    (fname, ext) = splitext(basename(rfile.name))
    parents = split(dirname(rfile.name), "/") |> reverse
    FileSummary(ext, fname, parents)
end
