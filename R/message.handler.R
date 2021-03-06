message.handler <- function(warnings, message=character(0), summarise = FALSE){
  # This function either stores or displays a summary of warnings
  # and errors.
  # ARGUMENTS
  #   - warnings is a list of two elements (message and counter)
  #   - message is the new message if one exists
  #   - summarise if TRUE it prints out a summary of the warnings
  if(length(message) > 0){
    # Check if the warning already exists
    message <- paste(message, collapse = " ")
    index <- which(warnings$message == message)
    if(length(index) == 0){
      no.warnings <- length(warnings$message)
      warnings$message[[no.warnings + 1]] <- message
      warnings$counter[[no.warnings + 1]] <- 1
    }else{
      warnings$counter[[index]] <- warnings$counter[[index]] + 1
    }  
  }else if(summarise){
    print("/nErrors//Warnings /n")
    for(i in seq(along = warnings$message)){
      cat(paste(warnings$message[[i]], "occured", warnings$counter[[i]], "time(s)", sep = " "))
    }
  }
  return(warnings)
}

