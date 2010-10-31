xml_file=points.xml
gps_data=/tmp/gpsdat
run_forever=1
marker_count=0

#Create the template for xml file
echo "<markers>" > $xml_file


cat $gps_data | while read LINE
do
        echo "$LINE"

        GPRMC=`echo $LINE |grep GPRMC| cut -d',' -f4,5,6,7`
        KNOT_SPEED=`echo $LINE |grep GPRMC| cut -d',' -f8`

        GPS_DAT_CHAR_COUNT=`echo $GPRMC | wc -c`

        if [ "$GPS_DAT_CHAR_COUNT" -ne "25" ]
        then
            echo " Incomplete data: $GPRMC "
            continue
        fi

        #Sometimes there is no data
        if [ -z "$GPRMC" ]
        then
            continue 
        fi

        ((marker_count= $marker_count + 1))
        echo $marker_count: $GPRMC
        #Get the Latitude degree
        LAT_DEG=`echo $GPRMC|cut -c1,2`
        echo LAT degree = $LAT_DEG

        LAT_MIN=`echo $GPRMC|cut -c3,4,5,6,7,8,9`
        echo LAT min = $LAT_MIN

        LAT_FLOAT=`echo "scale=7;$LAT_DEG + ($LAT_MIN/60.00)" | bc`
        echo LAT_FLOAT = $LAT_FLOAT

        #Get Longitude details
        LONG_DEG=`echo $GPRMC|cut -c13,14,15`
        echo LONG_DEG = $LONG_DEG

        LONG_MIN=`echo $GPRMC|cut -c16,17,18,19,20,21,22`
        echo LONG_MIN = $LONG_MIN

        LONG_FLOAT=`echo "scale=7;$LONG_DEG + ($LONG_MIN/60.00)" | bc`
        echo LONG_FLOAT = $LONG_FLOAT

        SPEED_KMPH=`echo "scale=7;$KNOT_SPEED * 1.85200" | bc`

        echo " <marker lat=\"-$LAT_FLOAT\" lng=\"$LONG_FLOAT\" html=\"Speed: $SPEED_KMPH\"  label=\"Marker $marker_count\" />" >> $xml_file


done

echo "</markers>" >> $xml_file 

