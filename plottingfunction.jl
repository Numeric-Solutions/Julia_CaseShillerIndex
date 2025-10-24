using DataFrames, CairoMakie, Colors

CairoMakie.activate!()

const MARKERSIZE = 15;

# define some colors here
# find more here:
# http://juliagraphics.github.io/Colors.jl/stable/namedcolors/
orange     = colorant"darkorange2";
green      = colorant"chartreuse3";
blue       = colorant"dodgerblue1";
yellow     = colorant"lightgoldenrod1";
red        = colorant"firebrick";
olivegreen = colorant"olive";
purple     = colorant"purple4";
teal       = colorant"teal";
brown      = colorant"darkgoldenrod4";
pink       = colorant"deeppink3";
grey       = colorant"grey0";
lightgrey  = colorant"grey79";
white      = colorant"gray100";


# Mackie Theme
function darktheme()
  dark  = (:gray10, 1.0)
  light = (:white, 0.8)
  med   = (:white, 0.15)
  fontsize = 20

  T = Theme(
    backgroundcolor = dark,
    textcolor = light,
    linecolor = med,
    fontsize = 25)

  A = (
      backgroundcolor = dark,
      xgridcolor = med,
      ygridcolor = med,

      leftspinevisible   = true,
      rightspinevisible  = true,
      bottomspinevisible = true,
      topspinevisible    = true,

      leftspinecolor   = light,
      rightspinecolor  = light,
      bottomspinecolor = light,
      topspinecolor    = light,

      xticksvisible = true,
      yticksvisible = true,

      xtickcolor = light,
      ytickcolor = light,

      xtickalign = 1,
      ytickalign = 1,

      xticksize = 10,
      yticksize = 10,

      xtickwidth = 2,
      ytickwidth = 2,

      xminorticksvisible = true,
      yminorticksvisible = true,
      
      xminortickcolor = light,
      yminortickcolor = light,

      xminortickalign = 1,
      yminortickalign = 1,

      xminorticksize = 5,
      yminorticksize = 5,

      xminorticks = IntervalsBetween(10),
      yminorticks = IntervalsBetween(5),

      xlabelpadding = 50,
      ylabelpadding = 30,

      xticksmirrored = true,
      yticksmirrored = true)

    L = (
      backgroundcolor = dark,
      # fontsize = 8,
      framevisible = false,
      padding = (0, 0, 0, 0))

    Cb = (
      ticksvisible = false,
      spinewidth = 0,
      ticklabelpad = 5)

    F = (
      backgroundcolor = dark,
      figure_padding = 50)

  return merge(T, Theme(Axis = A), Theme(Legend = L), Theme(Colorbar = Cb), Theme(Figure = F))
end

set_theme!(darktheme())

# CairoMakie line plot for arb number of waves
function plotxy(Vy;figure=Figure(size=(800,700)))
  ax = Axis(figure[1, 1])
  Ni = length(Vy)
  x = 1:length(Vy)
  lines!(ax, x, Vy)
  return figure
end

# CairoMakie line plot for arb number of waves
function plotxy(x, Vy...;figure=Figure(size=(800,700)))  
  ax = Axis(figure[1, 1])
  Ni = length(Vy)
  for i = 1:Ni
    lines!(ax, x, Vy[i])
  end
  return figure
end

function plotvxy(x::Vector{Vector{Float64}}, y::Vector{Vector{Float64}};figure=Figure(size=(800,700)))  
  ax = Axis(figure[1, 1])
  Ni = length(y)
  for i = 1:Ni
    lines!(ax, x[i], y[i])
  end
  return figure
end

function ploty(Vy... ;figure=Figure(size=(800,700)), Vyᵣ=nothing, cr=lightgrey, title = "")  
  
  ax1 = length(title) > 0 ? Axis(figure[1, 1], title = title) : Axis(figure[1, 1])
  Ni = length(Vy)
  for i = 1:Ni
    lines!(ax1, 1:length(Vy[i]), Vy[i])
  end

  if !isnothing(Vyᵣ)
    ax2 = Axis(figure[1, 1], yaxisposition = :right)
    lines!(ax2, 1:length(Vyᵣ), Vyᵣ, color = cr)
  end
  return figure
end

function ploty(Vy;figure=Figure(size=(800,700)), Vyᵣ=nothing, cr=lightgrey, title = "")  
  
  ax = length(title) > 0 ? Axis(figure[1, 1], title = title) : Axis(figure[1, 1])

  Ni = length(Vy)
  lines!(ax, 1:length(Vy), Vy)

  if !isnothing(Vyᵣ)
    ax2 = Axis(figure[1, 1], yaxisposition = :right)
    lines!(ax2, 1:length(Vyᵣ), Vyᵣ, color = cr)
  end
  return figure
end

# doesn't work
# function ploty(df::DataFrame)
#   vcol = [deepcopy(df[:, j]) for j ∈ 1:ncol(df)]
#   ploty(vcol)
# end

# CairoMakie scatter plot for just one wave
function scatterxy(Vy;figure=Figure(size=(800,700)))
  ax = Axis(figure[1, 1])
  Ni = length(Vy)
  x = 1:length(Vy)
  scatter!(ax, x, Vy, markersize=MARKERSIZE)
  return figure
end

# CairoMakie scatter plot for arb number of waves
function scatterxy(x, Vy...;figure=Figure(size=(800,700)))
  ax = Axis(figure[1, 1])
  Ni = length(Vy)
  for i = 1:Ni
    scatter!(ax, x, Vy[i][x], markersize=MARKERSIZE)
  end
  return figure
end

# CairoMakie scatter plot for arb number of waves
function scatterxy(x, y;figure=Figure(size=(800,700)), xfit=[], yfit=[])
  ax = Axis(figure[1, 1])
  scatter!(ax, x, y, markersize=MARKERSIZE)
  if length(yfit) > 0
    if length(xfit) == length(yfit)
      lines!(ax, xfit, yfit, color = yellow)
    elseif length(xfit) == 0
      lines!(x, yfit)
    else
      lines!(x, yfit[eachindex(x)])
    end
  end
  return figure
end

# plot vector field
function plotfield(x, y, vx, vy)
  f = Figure(800,800)
  Axis(f[1, 1])
  Vx  = ustrip.(x)
  Vy  = ustrip.(y)
  Vvx = ustrip.(vx)
  Vvy = ustrip.(vy)
  Ni = length(x)
  Vv = [norm([Vvx[i], Vvy[i]]) for i=1:Ni]
  arrows!(Vx, Vy, Vvx, Vvy, arrowsize = 10, lengthscale = 0.05,
      arrowcolor = Vv, linecolor = Vv)
  return f
end

# sawtooth function with period 2π
function sawtooth(θ)
  return mod(θ, 2π)/2π
end

# triangle function with period 2π
function triangle(θ)
  θ = mod(θ, 2π)
  y = 0
  if θ <= π/2
    y = θ
  elseif π/2 < θ < 3π/2
    y = π - θ
  elseif 3π/2 < θ < 2π
    y = -2π + θ
  end
  return y/(π/2)
end

# triangle function with period 2π
function square(θ)
  return mod(θ, 2π) < π ? 1 : -1
end
