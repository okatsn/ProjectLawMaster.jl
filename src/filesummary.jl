
abstract type Purpose end
struct FindingMingFa <: Purpose end

abstract type FromWhere end
struct InKey <: FromWhere
    value
end

struct AlongPath <: FromWhere
    directory
    level
end
struct OnFileName <: FromWhere end
struct InPlainText <: FromWhere end

struct FileSummary
    ext # extension
    fname # filename
    parents
    content
    uncompresssedsize
end

function FileSummary(rfile::ZipFile.ReadableFile)
    (fname, ext) = splitext(basename(rfile.name))
    parents = split(dirname(rfile.name), "/") |> reverse
    content = read(rfile, String)
    FileSummary(ext, fname, parents, content, rfile.uncompressedsize)
end

function DataFrames.DataFrame(::FindingMingFa, fs::FileSummary)
    df0 = DataFrame()
    if fs.ext == ".json" # find targets in keys
        d = JSON.parse(fs1.content)
        for (k, str) in d
            if k == "reason"
                _append_matches!(df0, str)
            end
            _append_matches!(df0, target_民事判決,  str, InKey(k))
            _append_matches!(df0, target_事實或理由, str, InKey(k))
        end
    else # find targets in raw strings
        _append_matches!(df0, target_民事判決,  fs.content, InPlainText())
        _append_matches!(df0, target_事實或理由, fs.content, InPlainText())
    end

    # find targets on filename
    _append_matches!(df0, target_民事判決,  fs.fname, OnFileName())

    # find targets on path
    for (i, p) in enumerate(fs.parents)
        _append_matches!(df0, target_民事判決,  fs.fname, AlongPath(p, i))
    end


    insertcols!(df, "uncompresssedsize" => fs.uncompresssedsize)
    insertcols!(df, "filename" => fs.fname)


end


function _append_matches!(df0, expr_target, str, found_in )
    mts2 = eachmatch(expr_target, str)
    for mt in mts2
        append!(df0,
            DataFrame(
                "target" => DataFrame(mt.match),
                "target_type" => expr_target,
                "target_in" => found_in
            )
        )
    end
end

function _append_matches!(df0, str)
    append!(df0,
        DataFrame(
            "target" => str,
            "target_type" => target_事實或理由,
            "target_in" => "reason"
        )
    )
end
