check.shapefile <- function(shapefile){
  #This fuction was added as there were some issues with shapefiles 
  #created by Distance. There seemed to be some redundant information added.
  #Also checks shapefile type
  if(!shapefile$shp$header$shape.type %in% c(5,15,25)){
    stop("The shapefile you have provided is of incorrect type. The shapefile must contain polygons.", call. = FALSE)
  }
  keep <- rep(NA, length(shapefile$shp$shp))
  for(i in seq(along=shapefile$shp$shp)){
    keep[i] <- shapefile$shp$shp[[i]]$shape.type %in% c(5,15,25)
  }
  index <- which(keep)
  new.shp.list <- list()
  for(i in seq(along = index)){
    new.shp.list[[i]] <- shapefile$shp$shp[[index[i]]]
  }
  shapefile$shp$shp <- new.shp.list
  return(shapefile)
}