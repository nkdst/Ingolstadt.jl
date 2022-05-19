

"One Implementation:"
"""
The selection operation is implemented as a tournament selection. 
In this case, we select a few individuals (tournament size) at random in the population. 
Then, the tournament takes place : with the probability ptour, the best individual from the sampled population is selected. 
Otherwise, we discard it and continue the tournament with the remaining individuals.
"""
function selectIndividual(tournamentSize::Int64, ptour::Float64, pop::Array{Individual,1})
    selected = Individual(0, 0, [], [], Inf)
    fitnesses = Array{Float64}(tournamentSize)
    subPop = sample(pop, tournamentSize, replace=true)
    for j in 1:tournamentSize
        fitnesses[j] = subPop[j].fitness
    end
    notSelected = true
    while notSelected
        mxval, mxindx = findmin(fitnesses)
        if rand(Float64) < ptour
            notSelected = false
            selected = subPop[mxindx]
        elseif length(fitnesses)==1
            selected = subPop[mxindx]
        else
            deleteat!(fitnesses, mxindx)
        end
    end
    return(selected)
end

"""
When we want to select multiple individuals, we simply loop until the desired amount is samled.
"""
function selectIndividuals(nInd::Int64, 
        tournamentSize::Int64, 
        ptour::Float64, 
        pop::Array{Individual,1}
    )
    selected = Array{Individual,1}(nInd)
    for i in 1:nInd
        selected[i] = selectIndividual(tournamentSize, ptour, pop)
    end
    return(selected)
end

"Very basic way to implement tournamentSelection"
function tournamentSelection(pop::Array{Individual,1})
    parents = []
    nPop = length(pop)
    children = Array{Individual}(nPop)
    parent = Array{Individual}(2)
    for i in 1:nPop
        for j in 1:2
            "Could be solved with smaple function from StatsBase.jl"
            fighter1 = pop[rand(1:nPop)]
            fighter2 = pop[rand(1:nPop)]
            if fighter1.fitness > fighter2.fitness
                parent[j] = fighter1
            else
                parent[j] = fighter2
        end
        children[i] = recombination(parent[1], parent[2])
    end
end