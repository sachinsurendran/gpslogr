run_forever=1

while [ $run_forever -gt 0 ]
do

GPRMC=`tail -n 1 /tmp/gpsdat |grep GPRMC| cut -d',' -f4,5,6,7`

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

echo $GPRMC
#Get the Latitude degree
LAT_DEG=`echo $GPRMC|cut -c1,2`
echo LAT degree = $LAT_DEG

LAT_MIN=`echo $GPRMC|cut -c3,4,5,6,7,8,9,11`
echo LAT min = $LAT_MIN

#Get Longitude details
LONG_DEG=`echo $GPRMC|cut -c13,14,15`
echo LONG_DEG = $LONG_DEG

LONG_MIN=`echo $GPRMC|cut -c16,17,18,19,20,21,22,24`
echo LONG_MIN = $LONG_MIN
echo "/usr/bin/firefox http://maps.google.com/maps?q=$LAT_DEG%20$LAT_MIN,$LONG_DEG%20$LONG_MIN&z=20 &"
echo "Opening browser"
/usr/bin/firefox http://maps.google.com/maps?q=$LAT_DEG%20$LAT_MIN,$LONG_DEG%20$LONG_MIN\&z=20 &

echo "Sleeping for 5 secs"

sleep 5 

done

