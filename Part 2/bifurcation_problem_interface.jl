using Setfield
function BifurcationKit.BifurcationProblem(rn::ReactionSystem, ps::Vector, p::Symbol, p_span::Tuple, s::Symbol)
    nsys = convert(NonlinearSystem,rn)
    ofun = NonlinearFunction(nsys; jac=true)
    F = ofun.f
    J = ofun.jac

    bif_idx = findfirst(isequal(p), ModelingToolkit.getname.(Catalyst.parameters(rn)))

    plot_idx = findfirst(isequal(s), ModelingToolkit.getname.(states(rn)))
    record_from_solution = (x, p) -> x[plot_idx]

    u0_guess = ModelingToolkit.varmap_to_vars(Pair.(states(nsys), ones(length(states(nsys)))), states(nsys))
    ps_in = ModelingToolkit.varmap_to_vars(Catalyst.symmap_to_varmap(rn,ps), Catalyst.parameters(nsys))
    ps_in[bif_idx] = p_span[1]
    return BifurcationKit.BifurcationProblem(F, u0_guess, ps_in, (@lens _[bif_idx]); record_from_solution = record_from_solution, J = J)
end;