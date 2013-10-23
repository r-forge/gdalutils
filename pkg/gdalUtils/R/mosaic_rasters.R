#' Mosaic raster files using GDAL Utilities
#' 
#' @param gdalfile Character. Input files (as a character vector) or a wildcard search term (e.g. "*.tif") 
#' @param dst_dataset Character. The destination file name.
#' @param output.vrt Character. Output VRT file.  If NULL a temporary .vrt file will be created.
#' @param output_Raster Logical. Return output dst_dataset as a RasterBrick?
#' @param ... Parameters to pass to \code{\link{gdalbuildvrt}} and \code{\link{gdal_translate}}.
#' @details This function mosaics a set of input rasters (gdalfile) using parameters
#' found in \code{\link{gdalbuildvrt}} and subsequently exports the mosaic to 
#' an output file (dst_dataset) using parameters found in \code{\link{gdal_translate}}.  The user
#' can choose to preserve the intermediate output.vrt file, but in general this is not
#' needed.
#' @return Either a list of NULLs or a list of RasterBricks depending on whether output_Raster is set to TRUE.
#' @author Jonathan A. Greenberg (\email{gdalUtils@@estarcion.net})
#' @seealso \code{\link{gdalbuildvrt}}, \code{\link{gdal_translate}}
#' @examples \dontrun{ 
#' layer1 <- system.file("external/tahoe_lidar_bareearth.tif", package="gdalUtils")
#' layer2 <- system.file("external/tahoe_lidar_highesthit.tif", package="gdalUtils")
#' mosaic_rasters(gdalfile=c(layer1,layer2),dst_dataset="test_mosaic.envi",separate=TRUE,of="ENVI",
#' 		verbose=TRUE)
#' gdalinfo("test_mosaic.envi")
#' }
#' @export

mosaic_rasters <- function(gdalfile,dst_dataset,output.vrt=NULL,output_Raster=FALSE,...)
{
	if(is.null(output.vrt))
	{
		output.vrt <- paste(tempfile(),".vrt",sep="")
	}
	
	# Do some file exists testing here
	
	gdalbuildvrt(gdalfile=gdalfile,output.vrt=output.vrt,...)
	outmosaic <- gdal_translate(src_dataset=output.vrt,dst_dataset=dst_dataset,
		output_Raster=output_Raster,...)
	return(outmosaic)
	
}