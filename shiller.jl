using DataFrames, Downloads, CSV, CairoMakie, Colors
CairoMakie.activate!()

include("plottingfunction.jl")

# URL to Case-Shiller Home Price Index
housingurl = "https://fred.stlouisfed.org/graph/fredgraph.csv?id=CSUSHPINSA"

# Download as CSV string
str = Downloads.download(housingurl)

# convert to DataFrame, using CSV package
dfh  = CSV.read(str, DataFrame)

# Plot using plotxy() (defined in plottingfunction.jl)
plotxy(dfh.observation_date, dfh.CSUSHPINSA)
