@testset "test_expression.jl" begin
    @test occursin(ProjectLawMaster.target_民事判決, "我是一個路徑/路徑_bla/檔名_含有_民事判決.json")
    @test occursin(ProjectLawMaster.target_民事判決, "檔名_含有_XX民事判決FooBar_Bla.json")
    @test occursin(ProjectLawMaster.target_民事判決, "檔名_含有_XX民事FooBar_Bla.json")
    @test occursin(ProjectLawMaster.target_事實或理由, "小明昨天很開心，基於這樣的事實與理由，小美也很開心。")
    @test occursin(ProjectLawMaster.target_事實或理由, "小明昨天很開心，基於這樣的事實，小美也很開心。")
end
