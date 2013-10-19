
### gdal_rasterize

dst_filename_original  <- system.file("external/tahoe_highrez.tif", package="gdalUtils")
# Back up the file, since we are going to burn stuff into it.
dst_filename <- paste(tempfile(),".tif",sep="")
file.copy(dst_filename_original,dst_filename,overwrite=TRUE)

# Before plot:
plotRGB(brick(dst_filename))

src_dataset <- system.file("external/tahoe_highrez_training.shp", package="gdalUtils")

# gdal_rasterize -b 1 -b 2 -b 3 -burn 255 -burn 0 -burn 0 -l tahoe_highrez_training tahoe_highrez_training.shp tempfile.tif
tahoe_burned <- gdal_rasterize(src_dataset,dst_filename,
	b=c(1,2,3),burn=c(0,255,0),l="tahoe_highrez_training",verbose=TRUE,output_Raster=TRUE)

plotRGB(brick(dst_filename))

#### gdaldem
input_dem  <- system.file("external/tahoe_lidar_highesthit.tif", package="gdalUtils")
plot(raster(input_dem),col=gray.colors(256))

# Hillshading:
# Command-line gdaldem call:
# gdaldem hillshade tahoe_lidar_highesthit.tif output_hillshade.tif
output_hillshade <- gdaldem(mode="hillshade",input_dem=input_dem,output="output_hillshade.tif",output_Raster=TRUE)
plot(output_hillshade,col=gray.colors(256))

# Slope:
# Command-line gdaldem call:
# gdaldem slope tahoe_lidar_highesthit.tif output_slope.tif -p
output_slope <- gdaldem(mode="slope",input_dem=input_dem,output="output_slope.tif",p=TRUE,output_Raster=TRUE)
plot(output_slope,col=gray.colors(256))

# Aspect:
# Command-line gdaldem call:
# gdaldem aspect tahoe_lidar_highesthit.tif output_aspect.tif
output_aspect <- gdaldem(mode="aspect",input_dem=input_dem,output="output_aspect.tif",output_Raster=TRUE)
plot(output_aspect,col=gray.colors(256))

