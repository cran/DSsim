create.results.arrays <- function(reps, region.obj, ddf.analyses.list, population.description.obj){
  # Make the results arrays and store in a list
  no.strata <- ifelse(length(region.obj@strata.name) > 0, length(region.obj@strata.name)+1, 1) 
  # Check to see if the strata are grouped in the analyses
  new.strata.names <- NULL
  if(nrow(ddf.analyses.list[[1]]@analysis.strata) > 0){
    new.strata.names <- unique(ddf.analyses.list[[1]]@analysis.strata$analysis.id)  
  }else{
    new.strata.names <- NULL
  }
  if(length(region.obj@strata.name) > 0){
    if(!is.null(new.strata.names)){
      strata.name <- c(sort(new.strata.names), "Total")
      no.strata <- length(strata.name)
    }else{
      strata.name <- c(sort(region.obj@strata.name), "Total")  
    }
  }else{
    strata.name <- region.obj@region.name
  }
  individuals <- list(summary = array(NA, dim = c(no.strata, 8, reps+2), dimnames = list(strata.name, c("Area", "CoveredArea", "Effort", "n", "n.miss.dist", "ER", "se.ER", "cv.ER"), c(1:reps,"mean","sd"))), 
                      N = array(NA, dim = c(no.strata, 6, reps+2), dimnames = list(strata.name, c("Estimate", "se", "cv", "lcl", "ucl", "df"), c(1:reps,"mean","sd"))), 
                      D = array(NA, dim = c(no.strata, 6, reps+2), dimnames = list(strata.name, c("Estimate", "se", "cv", "lcl", "ucl", "df"), c(1:reps,"mean", "sd"))))
  detection = array(NA, dim = c(1, 7, reps+2), dimnames = list("Pooled", c("True.Pa", "Pa", "ESW", "f(0)", "SelectedModel", "DeltaCriteria", "SuccessfulModels"), c(1:reps,"mean","sd")))
  #create additional arrays if animals are in clusters
  if(population.description.obj@size){
    clusters <- list(summary = array(NA, dim = c(no.strata, 9, reps+2), dimnames = list(strata.name, c("Area", "CoveredArea", "Effort", "n", "n.miss.dist", "k", "ER", "se.ER", "cv.ER"), c(1:reps,"mean","sd"))), 
                     N = array(NA, dim = c(no.strata, 6, reps+2), dimnames = list(strata.name, c("Estimate", "se", "cv", "lcl", "ucl", "df"), c(1:reps,"mean","sd"))), 
                     D = array(NA, dim = c(no.strata, 6, reps+2), dimnames = list(strata.name, c("Estimate", "se", "cv", "lcl", "ucl", "df"), c(1:reps,"mean", "sd"))))
    expected.size <- array(NA, dim = c(no.strata, 3, reps+2), dimnames = list(strata.name, c("Expected.S", "se.Expected.S", "cv.Expected.S"), c(1:reps,"mean","sd")))
    results <- list(individuals = individuals, clusters = clusters, expected.size = expected.size, Detection = detection)
  }else{
    results <- list(individuals = individuals, Detection = detection)
  }
  return(results)
}