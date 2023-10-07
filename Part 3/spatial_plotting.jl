using GLMakie
using Makie.Colors
make_mat(vec) = reshape(vec,2,Int64(length(vec)/2))
function animate_spatial_sol(sol, n, m=n; var=1, framerate=round(Int64,length(sol.t)/30), outputname = "spatial_animation.mp4")
    if sol.u isa Vector{Matrix{Int64}}
        remade_sol = sol.u[1:floor(Int64, length(sol.t)/1000):end]
    else
        remade_sol = make_mat.(sol.u)
    end
    function color_scale(x, y, i)
        remade_sol[i][var,n*(Int64(y)-1) + Int64(x)]
    end

    x_range = 1:n
    y_range = 1:m
    vals0 = [color_scale(x,y,1) for x in x_range, y in y_range]
    fig, ax, hm = heatmap(x_range, y_range, vals0)

    record(fig, outputname, 1:length(remade_sol);
        framerate = framerate) do i
        hm[3] = [color_scale(x,y,i) for x in x_range, y in y_range]
    end
end;