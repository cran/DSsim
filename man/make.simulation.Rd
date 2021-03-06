% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Class.Constructors.R
\name{make.simulation}
\alias{make.simulation}
\title{Creates a Simulation object}
\usage{
make.simulation(
  reps = 10,
  single.transect.set = FALSE,
  double.observer = FALSE,
  region.obj = make.region(),
  design.obj = make.design(),
  population.description.obj = make.population.description(),
  detectability.obj = make.detectability(),
  ddf.analyses.list = make.ddf.analysis.list()
)
}
\arguments{
\item{reps}{number of times the simulation should be repeated}

\item{single.transect.set}{logical specifying whether the transects should
be kept the same throughout the simulation.}

\item{double.observer}{not currently implemented.}

\item{region.obj}{an object of class Region created by a call to
\link{make.region}}

\item{design.obj}{an object of class Survey.Design created by a call to
\link{make.design}}

\item{population.description.obj}{an object of class Population.Description
created by a call to \link{make.population.description}}

\item{detectability.obj}{and object of class Detectabolity created by a call to
\link{make.detectability}}

\item{ddf.analyses.list}{a list of objects of class DDF.Analysis created by 
a call to\link{make.ddf.analysis.list}}
}
\value{
object of class Simulation
}
\description{
This creates a simulation with all the information necessary for DSsim
to generate a population, create or read in transects, simulate the survey process
and fit detection functions and estimate density / abundance. This function can be
used by itself based on default values to create a simple line transect example, see
Examples below. To create more complex simulations it is advisable to define the 
different parts of the simulation individually before grouping them together. See
the Arguments for links to the functions which make the definitions for the 
individual simulation components. Example simulations can also be found at
<https://github.com/DistanceDevelopment/DSsim/wiki>.
}
\details{
The \code{make.simulation} function is now set up so that by
 default (with the exception of specifying point transects rather than
  line) it can run a simple simulation example. See examples.
}
\examples{
\dontrun{
# A basic line transect simulation example
sim <- make.simulation()
check.sim.setup(sim)
sim <- run(sim) 
summary(sim)

# A basic point transect simulation example
sim <- make.simulation(design.obj = make.design("point"))
check.sim.setup(sim)
sim <- run(sim) 
summary(sim)
# Note \% bias levels will vary due to low number of repetitions 
# set by default in these examples

# To increase the number of repetitions
sim <- make.simulation(reps = 100)
sim <- run(sim) 
summary(sim)
}

coords <- gaps <- list()
coords[[1]] <- list(data.frame(x = c(0,1000,1000,0,0), y = c(0,0,
 1000,1000,0)))
gaps[[1]] <- list(data.frame(x = c(400,600,500,350,400), y = c(100,
 250,600,120,100)))

region <- make.region(region.name = "study.area", units = "m", 
 coords = coords, gaps = gaps)
plot(region)

\dontrun{
data(transects.shp)
#Edit the pathway below to point to an empty folder where the
#transect shapefile will be saved
shapefile.pathway <- "C:/..."
write.shapefile(transects.shp, paste(shapefile.pathway,"/transects_1",
 sep = ""))

parallel.design <- make.design(transect.type = "Line", 
 design.details = c("Parallel","Systematic"), region = region, 
 design.axis = 0, spacing = 100, plus.sampling =FALSE, 
 path = shapefile.pathway)

pop.density <- make.density(region.obj = region, x.space = 10, 
 y.space = 10, constant = 0.5) 
pop.density <- add.hotspot(pop.density, centre = c(50, 200), 
 sigma = 100, amplitude = 0.1)
pop.density <- add.hotspot(pop.density, centre = c(500, 700), 
 sigma = 900, amplitude = 0.05)
pop.density <- add.hotspot(pop.density, centre = c(300, 100), 
 sigma = 100, amplitude = -0.15)

plot(pop.density)
plot(region, add = TRUE)

pop.description <- make.population.description(N = 1000, 
 density.obj = pop.density, region = region, fixed.N = TRUE)

detect <- make.detectability(key.function = "hn", scale.param = 15,
 truncation = 30) 

ddf.analyses <- make.ddf.analysis.list(dsmodel = list(~cds(key = "hn",
 formula = ~1),~cds(key = "hr", formula = ~1)), method = "ds", 
 criteria = "AIC")

my.simulation <- make.simulation(reps = 10, single.transect.set = TRUE,
 region.obj = region, design.obj = parallel.design, 
 population.description.obj = pop.description, 
 detectability.obj = detect, ddf.analyses.list = ddf.analyses)

survey.results <- create.survey.results(my.simulation, dht.table = TRUE)

plot(survey.results)

my.simulation <- run(my.simulation)

summary(my.simulation)
}

}
\author{
Laura Marshall
}
