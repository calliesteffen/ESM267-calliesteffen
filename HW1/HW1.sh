#ESM267_ASSIGNMENT1_Callie_Steffen    
# set -x lets you see the commands as they are executed
 
set -x


	
ogr2ogr -t_srs EPSG:3310 county_projection.shp tl_2018_us_county/tl_2018_us_county.shp
#reproject the county shapefile into 3310 and named it country_projection

ogr2ogr -where "name='Santa Barbara'" sb_projection.shp county_projection.shp
#filter santa barbara county from the new projected country file named county_projection and name the new file sb_projection.shp

# a list of the rasters that we want to clip and project
    
rasters="crefl2_A2019257204722-2019257205812_250m_ca-south-000_143.tif"

#region of interest is the shapfile of SB county projected in 3310
roi=sb_projection.shp

common_args="-dstalpha -of GTiff -co COMPRESS=DEFLATE -overwrite"

    # arguments for the clip command
    # -cutline $roi    : clip the input to the shapefile $roi
    # -crop_to_cutline : clip to the shape (not just its bounding box)
    #
clip_args="-cutline $roi -crop_to_cutline"

    # arguments for the project command
    # -t_srs EPSG:3310 for NAD83 California Teal Albers 
    #
project_args="-t_srs EPSG:3310"

    # loop through all the files listed in $rasters
    #
for file in $rasters
do
      
    
    gdalwarp $common_args $clip_args $file ${file}_clipped.tif

    gdalwarp $common_args $project_args ${file}_clipped.tif ${file}_albers.tif
done
 