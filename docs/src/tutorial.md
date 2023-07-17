```@meta
CurrentModule = ProjectLawMaster
```

# Example

```@example demo1
using JSON, CorpusCleanerForTWLaws
using ProjectLawMaster
using Test

file0 = ProjectLawMaster.project_dir("corpus", "judicial_yuan_qa.json")
file1 = ProjectLawMaster.project_dir("corpus", "judicial_yuan_qa_CLEANED.json")

# # Load corpus as a CorpusType
rawcorpus = JSON.parsefile(file0)
```

```@example demo1
cps = [CorpusJudicalYuan(d) for d in rawcorpus]

# # Clean the corpus
clean!.(cps)

# # Save results as JSON file
open(file1, "w") do io
    CorpusCleanerForTWLaws.print(io, cps)
end

# # Test if JSON file is correctly saved
@testset "test results" begin
    rawcorpus1 = JSON.parsefile(file1)
    for (c0, c1) in zip(cps, rawcorpus1)
        @test c0.question == c1["instruction"]
        @test c0.answer == c1["output"]
        @test isempty(c1["input"])
    end
end
```