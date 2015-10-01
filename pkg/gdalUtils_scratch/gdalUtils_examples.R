library(gdalUtils)

### gdal_rasterize
gdal_setInstallation()
valid_install <- !is.null(getOption("gdalUtils_gdalPath"))
if(require(raster) && require(rgdal) && valid_install)
{
# Example from the original gdal_rasterize documentation:
# gdal_rasterize -b 1 -b 2 -b 3 -burn 255 -burn 0
# 	-burn 0 -l tahoe_highrez_training tahoe_highrez_training.shp tempfile.tif
	dst_filename_original  <- system.file("external/tahoe_highrez.tif", package="gdalUtils")
# Back up the file, since we are going to burn stuff into it.
	dst_filename <- paste(tempfile(),".tif",sep="")
	file.copy(dst_filename_original,dst_filename,overwrite=TRUE)
#Before plot:
	plotRGB(brick(dst_filename))
	src_dataset <- system.file("external/tahoe_highrez_training.shp", package="gdalUtils")
	tahoe_burned <- gdal_rasterize(src_dataset,dst_filename,
			b=c(1,2,3),burn=c(0,255,0),l="tahoe_highrez_training",verbose=TRUE,output_Raster=TRUE)
#After plot:
	plotRGB(brick(dst_filename))
}

### gdal_translate
# We'll pre-check to make sure there is a valid GDAL install
# and that raster and rgdal are also installed.
# Note this isn't strictly neccessary, as executing the function will
# force a search for a valid GDAL install.
gdal_setInstallation()
valid_install <- !is.null(getOption("gdalUtils_gdalPath"))
if(require(raster) && require(rgdal) && valid_install)
{
# Example from the original gdal_translate documentation:
	src_dataset <- system.file("external/tahoe_highrez.tif", package="gdalUtils")
# Original gdal_translate call:
# gdal_translate -of GTiff -co "TILED=YES" tahoe_highrez.tif tahoe_highrez_tiled.tif
	gdal_translate(src_dataset,"tahoe_highrez_tiled.tif",of="GTiff",co="TILED=YES",verbose=TRUE)
# Pull out a chunk and return as a raster:
	gdal_translate(src_dataset,"tahoe_highrez_tiled.tif",of="GTiff",
			srcwin=c(1,1,100,100),output_Raster=TRUE,verbose=TRUE)
# Notice this is the equivalent, but follows gdal_translate's parameter format:
	gdal_translate(src_dataset,"tahoe_highrez_tiled.tif",of="GTiff",
			srcwin="1 1 100 100",output_Raster=TRUE,verbose=TRUE)
}


### gdaladdo
# We'll pre-check to make sure there is a valid GDAL install.
# Note this isn't strictly neccessary, as executing the function will
# force a search for a valid GDAL install.
gdal_setInstallation()
valid_install <- !is.null(getOption("gdalUtils_gdalPath"))
if(valid_install)
{
	filename  <- system.file("external/tahoe_highrez.tif", package="gdalUtils")
	temp_filename <- paste(tempfile(),".tif",sep="")
	file.copy(from=filename,to=temp_filename,overwrite=TRUE)
	gdalinfo(filename)
	gdaladdo(r="average",temp_filename,levels=c(2,4,8,16),verbose=TRUE)
	gdalinfo(temp_filename)
}


### gdalbuildvrt
?gdalbuildvrt

# We'll pre-check to make sure there is a valid GDAL install.
# Note this isn't strictly neccessary, as executing the function will
# force a search for a valid GDAL install.
gdal_setInstallation()
valid_install <- !is.null(getOption("gdalUtils_gdalPath"))
if(valid_install)
{
	layer1 <- system.file("external/tahoe_lidar_bareearth.tif", package="gdalUtils")
	layer2 <- system.file("external/tahoe_lidar_highesthit.tif", package="gdalUtils")
	output.vrt <- paste(tempfile(),".vrt",sep="")
	gdalbuildvrt(gdalfile=c(layer1,layer2),output.vrt=output.vrt,separate=TRUE,verbose=TRUE)
	gdalinfo(output.vrt)
}

### gdaldem
?gdaldem

# We'll pre-check to make sure there is a valid GDAL install
# and that raster and rgdal are also installed.
# Note this isn't strictly neccessary, as executing the function will
# force a search for a valid GDAL install.
gdal_setInstallation()
valid_install <- !is.null(getOption("gdalUtils_gdalPath"))
if(require(raster) && require(rgdal) && valid_install)
{
# We'll pre-check for a proper GDAL installation before running these examples:
	gdal_setInstallation()
	if(!is.null(getOption("gdalUtils_gdalPath")))
	{
		input_dem  <- system.file("external/tahoe_lidar_highesthit.tif", package="gdalUtils")
		plot(raster(input_dem),col=gray.colors(256))
		
# Hillshading:
# Command-line gdaldem call:
# gdaldem hillshade tahoe_lidar_highesthit.tif output_hillshade.tif
		output_hillshade <- gdaldem(mode="hillshade",input_dem=input_dem,
				output="output_hillshade.tif",output_Raster=TRUE,verbose=TRUE)
		plot(output_hillshade,col=gray.colors(256))
		
# Slope:
# Command-line gdaldem call:
# gdaldem slope tahoe_lidar_highesthit.tif output_slope.tif -p
		output_slope <- gdaldem(mode="slope",input_dem=input_dem,
				output="output_slope.tif",p=TRUE,output_Raster=TRUE,verbose=TRUE)
		plot(output_slope,col=gray.colors(256))
		
# Aspect:
# Command-line gdaldem call:
# gdaldem aspect tahoe_lidar_highesthit.tif output_aspect.tif
		output_aspect <- gdaldem(mode="aspect",input_dem=input_dem,
				output="output_aspect.tif",output_Raster=TRUE,verbose=TRUE)
		plot(output_aspect,col=gray.colors(256))
	}
}


### gdalinfo
?gdalinfo

# We'll pre-check to make sure there is a valid GDAL install.
# Note this isn't strictly neccessary, as executing the function will
# force a search for a valid GDAL install.
gdal_setInstallation()
valid_install <- !is.null(getOption("gdalUtils_gdalPath"))
if(valid_install)
{
	src_dataset <- system.file("external/tahoe_highrez.tif", package="gdalUtils")
# Command-line gdalinfo call:
# gdalinfo tahoe_highrez.tif
	gdalinfo(src_dataset,verbose=TRUE)
}

### gdalsrsinfo
?gdalsrsinfo

# We'll pre-check to make sure there is a valid GDAL install.
# Note this isn't strictly neccessary, as executing the function will
# force a search for a valid GDAL install.
gdal_setInstallation()
valid_install <- !is.null(getOption("gdalUtils_gdalPath"))
if(valid_install)
{
	src_dataset <- system.file("external/tahoe_highrez.tif", package="gdalUtils")
# Command-line gdalsrsinfo call:
# gdalsrsinfo -o proj4 tahoe_highrez.tif
	gdalsrsinfo(src_dataset,o="proj4",verbose=TRUE)
# Export as CRS:
	gdalsrsinfo(src_dataset,as.CRS=TRUE,verbose=TRUE)
}

### gdalwarp
?gdalwarp

# We'll pre-check to make sure there is a valid GDAL install
# and that raster and rgdal are also installed.
# Note this isn't strictly neccessary, as executing the function will
# force a search for a valid GDAL install.
gdal_setInstallation()
valid_install <- !is.null(getOption("gdalUtils_gdalPath"))
if(require(raster) && require(rgdal) && valid_install)
{
# Example from the original gdal_translate documentation:
	src_dataset <- system.file("external/tahoe_highrez.tif", package="gdalUtils")
# Command-line gdalwarp call:
# gdalwarp -t_srs '+proj=utm +zone=11 +datum=WGS84' raw_spot.tif utm11.tif
	gdalwarp(src_dataset,dstfile="tahoe_highrez_utm11.tif",
			t_srs='+proj=utm +zone=11 +datum=WGS84',output_Raster=TRUE,
			verbose=TRUE,overwrite=TRUE)
}

### ogr2ogr
?ogr2ogr

# We'll pre-check to make sure there is a valid GDAL install.
# Note this isn't strictly neccessary, as executing the function will
# force a search for a valid GDAL install.
gdal_setInstallation()
valid_install <- !is.null(getOption("gdalUtils_gdalPath"))
if(valid_install)
{
	src_datasource_name <- system.file("external/tahoe_highrez_training.shp", package="gdalUtils")
	dst_datasource_name <- paste(tempfile(),".shp",sep="")
	ogrinfo(src_datasource_name,"tahoe_highrez_training",verbose=TRUE)
# reproject the input to mercator
	ogr2ogr(src_datasource_name,dst_datasource_name,t_srs="EPSG:3395",verbose=TRUE)
	ogrinfo(dirname(dst_datasource_name),layer=remove_file_extension(basename(dst_datasource_name)),verbose=TRUE)
}

### ogrinfo
?ogrinfo

gdal_setInstallation()
valid_install <- !is.null(getOption("gdalUtils_gdalPath"))
if(valid_install)
{
	datasource_name <- system.file("external/tahoe_highrez_training.shp", package="gdalUtils")
# Display all available formats:
# Command-line ogrinfo call:
# ogrinfo --formats
	ogrinfo(formats=TRUE,verbose=TRUE)
	
# Get info on an entire shapefile:
# ogrinfo tahoe_highrez_training.shp
	ogrinfo(datasource_name,verbose=TRUE)
	
# Get info on the layer of the shapefile:
# ogrinfo tahoe_highrez_training.shp tahoe_highrez_training
	ogrinfo(datasource_name,"tahoe_highrez_training",verbose=TRUE)
}


### gdal_contour
gdal_setInstallation()
valid_install <- !is.null(getOption("gdalUtils_gdalPath"))
# We'll pre-check for a proper GDAL installation before running the examples:
if(valid_install && require(rgdal))
{
	input_dem  <- system.file("external/tahoe_lidar_highesthit.tif", package="gdalUtils")
	plot(raster(input_dem),col=gray.colors(256))
	output_contours <- gdal_contour(src_filename=input_dem,dst_filename="contour.shp",a="elev",i=10.0,output_Vector=TRUE)
	plot(output_contours)
}