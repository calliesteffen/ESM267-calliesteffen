ESM267_ASSIGNMENT1_Callie_Steffen    
# this lets you see the commands as they are executed
 
set -x

    # a list of the rasters that we want to clip and project
    
rasters="crefl2_A2019257204722-2019257205812_250m_ca-south-000_143"

ogrinfo-al -so tl_2018_us_county/tl_2018_us_county.shp
    # the shapefile that the rasters will be clipped to- We want santa barbara county 
  
roi=tl_2018_us_county.shp

    # arguments used by all the GDAL commands we'll run
    # -dstnotata -32768    : use -32768 as the output NO_DATA value
    # -of GTiff            : make the output raster a GeoTIFF
    # -co COMPRESS=DEFLATE : use the "DEFLATE" TIFF compression method
    # -overwrite           : overwrite the output raster if it already exists
    #
common_args="-dstnodata -32768 -of GTiff -co COMPRESS=DEFLATE -overwrite"

    # arguments for the clip command
    # -cutline $roi    : clip the input to the shapefile $roi
    # -crop_to_cutline : clip to the shape (not just its bounding box)
    #
clip_args="-cutline $roi -crop_to_cutline"

    # arguments for the project command
    # -t_srs EPSG:3310 for NAD83 California Teal Albers : use UTM zone 10N for the output coordinate system
    #
project_args="-t_srs EPSG:3310"

    # loop through all the files listed in $rasters
    #
for file in $rasters
do
        # clip ESRI grid InVEST_CV/$file into GeoTIFF ${file}_clipped.tif
        #
    gdalwarp $common_args $clip_args InVEST_CV/$file ${file}_clipped.tif

        # project GeoTIFF ${file}_clipped.tif into GeoTIFF ${file}_utm10n.tif
        #
    gdalwarp $common_args $project_args ${file}_clipped.tif ${file}_utm10n.tif
done