#This file shows some commonly used functionss used in bulk RNA seq analysis using DESeq2

#convertIDs is used to convert gene identifiers from one database to gene identifiers of another database in the differential gene expression data

convertIDs <- function( ids, fromKey, toKey, db, ifMultiple=c( "putNA", "useFirst" ) ) {
  stopifnot( inherits( db, "AnnotationDb" ) )
  ifMultiple <- match.arg( ifMultiple )
  suppressWarnings( selRes <- AnnotationDbi::select( 
    db, keys=ids, keytype=fromKey, columns=c(fromKey,toKey) ) )
  if( ifMultiple == "putNA" ) {
    duplicatedIds <- selRes[ duplicated( selRes[,1] ), 1 ]   
    selRes <- selRes[ ! selRes[,1] %in% duplicatedIds, ] }
  return( selRes[ match( ids, selRes[,1] ), 2 ] )
}


#The firstup function will capitalize only the first letter in a list of words
firstup <- function(x) {
  substr(x, 1, 1) <- toupper(substr(x, 1, 1))
  x
}


#The addline_format function will add a line break to axis labels in ggplot
addline_format <- function(x,...){
  gsub("([^ ]+ [^ ]+ [^ ]+ [^ ]+) ", "\\1\n", x)
}
