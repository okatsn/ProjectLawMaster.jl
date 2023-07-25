
abstract type Purpose end
struct FindingMingFa <: Purpose end

abstract type FromWhere end
struct InKey <: FromWhere
    value
    parent
end

struct Field <: FromWhere
    value
end

function InKey(value)
    InKey(value, 0)
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
    readable::Bool
end

function FileSummary(rfile::ZipFile.ReadableFile)
    (fname, ext) = splitext(basename(rfile.name))
    parents = split(dirname(rfile.name), "/") |> reverse
    content = ""
    readable = true
    try
        content = read(rfile, String)
    catch
        readable = false
    end
    FileSummary(ext, fname, parents, content, rfile.uncompressedsize, readable)
end

function DataFrames.DataFrame(::FindingMingFa, fs::FileSummary)
    df0 = DataFrame()
    if !fs.readable
        return df0
    end
    if fs.ext == ".json" # find targets in keys
        d = JSON.parse(fs.content)
        for (k, str) in d
            if k == "reason"
                _append_matches!(df0, str, Field("reason"))
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


    insertcols!(df0, :uncompresssedsize => fs.uncompresssedsize)
    insertcols!(df0, :filename => fs.fname)
    insertcols!(df0, :path_to_file => join(reverse(fs.parents), "/"))
    df0
end

function _append_matches!(df0, expr_target, d::Dict, found_in)
    for (k, v) in d
        _append_matches!(df0, expr_target, v, InKey(k, found_in))
    end
end

function _append_matches!(df0, expr_target, v::Vector, found_in)
    for item in v
        _append_matches!(df0, expr_target, item, found_in)
    end
end

# TODO: use holy trait to exclude any non-iterable things
# Otherwise, you can do nothing.
function _append_matches!(df0, expr_target, item, found_in)
    df0
end

function _append_matches!(df0, expr_target, str::AbstractString, found_in )
    mts2 = eachmatch(expr_target, str)
    for mt in mts2
        append!(df0,
            DataFrame(
                :target => mt.match,
                :target_type => expr_target,
                :target_in => found_in
            ); promote=true, cols = :union
        )
    end
end # FIXME: will `; promote=true, cols = :union` results in low performance?

# FIXME: This is not general and extensible
function _append_matches!(df0, str, found_in)
    append!(df0,
        DataFrame(
            :target => str,
            :target_type => target_事實或理由,
            :target_in => found_in
        ); promote=true, cols = :union
    )
end
