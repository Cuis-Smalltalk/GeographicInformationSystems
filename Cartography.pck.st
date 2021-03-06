'From Cuis 5.0 [latest update: #4594] on 10 May 2021 at 4:28:51 pm'!
'Description '!
!provides: 'Cartography' 1 18!
!requires: 'Math 3D' 1 4 nil!
!requires: 'Graphics-Files-Additional' 1 4 nil!
SystemOrganization addCategory: 'Cartography'!


!classDefinition: #GPSPosition category: 'Cartography'!
Float64Array variableWordSubclass: #GPSPosition
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Cartography'!
!classDefinition: 'GPSPosition class' category: 'Cartography'!
GPSPosition class
	instanceVariableNames: ''!

!classDefinition: #CartographicProjection category: 'Cartography'!
Object subclass: #CartographicProjection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Cartography'!
!classDefinition: 'CartographicProjection class' category: 'Cartography'!
CartographicProjection class
	instanceVariableNames: ''!

!classDefinition: #MercatorProjection category: 'Cartography'!
CartographicProjection subclass: #MercatorProjection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Cartography'!
!classDefinition: 'MercatorProjection class' category: 'Cartography'!
MercatorProjection class
	instanceVariableNames: ''!

!classDefinition: #WebmercatorProjection category: 'Cartography'!
CartographicProjection subclass: #WebmercatorProjection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Cartography'!
!classDefinition: 'WebmercatorProjection class' category: 'Cartography'!
WebmercatorProjection class
	instanceVariableNames: ''!


!GPSPosition commentStamp: 'jmv 3/2/2015 13:34' prior: 0!
GPS like position: Latitude, Longitude, Altitude (or Height or Elevation). Reference is the WGS 84 ellipsoid.
Latitude is geodetic, in degrees. Positive values are north the equator, negative values are south.
Longitude is in degrees, 0.0 is close to Greenwich. Positive values are east of Greenwich, negative values are west.
Altitude is in meters. 0.0 is the WGS 84 ellipsoid.!

!CartographicProjection commentStamp: '<historical>' prior: 0!
Provides services for converting (x, y) coordinates on a map to and from geographic / geodetic latitude and longitude.!

!MercatorProjection commentStamp: 'jmv 3/17/2015 11:05' prior: 0!
See http://en.wikipedia.org/wiki/Mercator_projection
See "Maps projections, a working manual", p.37

Mercator projection is:
- Cylindrical.
- Conformal.
- Meridians are equally spaced straight lines.
- Parallels are unequally spaced straight lines, closest near the Equator, cutting meridians at right angles.
- Scale is true along the Equator, or along two parallels equidistant from the Equator. (jmv: or along any single parallel)
- Loxodromes (rhumb lines) are straight lines.
- Not perspective.
- Poles are at infinity; great distortion of area in polar regions.
- Used for navigation.
- Presented by Mercator in 1569.
- (jmv: preserves areas, shapes and scales in small areas)

Mercator projection is centered at the Equator and meridian 0 (Greenwich).!

!WebmercatorProjection commentStamp: 'jmv 8/13/2018 14:02:18' prior: 0!
As in http://en.wikipedia.org/wiki/Web_Mercator
Used by http://www.openstreetmap.org , http://maps.google.com , etc
Uses elliptic (geodetic) latitude and longitude for, but projects them using a spherical model of Earth.
In different words, we take geodetic (elliptical Earth) (latitude, longitude), and do a spherical Mercator projection as if our latitude and longitude were spherical (defined on the sphere). As there is a slight distorion going from the ellipsoid to the sphere, the PseudoMercatorProjection is not conformal, but almost.

| tm ww hh e webmercator proj ll xInTM yInTM |
tm _ Form fromFileNamed: 'payload/datasets/NaturalEarthPlusBathymetry/NE_Drape-3000x1500.tif'.
ww _ tm width.
hh _ tm height.
e _ 900.
webmercator _ Form extent: e@e depth: 32.
proj _ WebmercatorProjection new.
0 to: webmercator height by: 1 do: [ :y | 0 to: webmercator width by: 1 do: [ :x |
		ll _ proj latLongFromMapPosition: x@y / e.
		xInTM _ ll lambda + 180 / 360 * ww.
		yInTM _ 90 - ll phi / 180 * hh.
		webmercator colorAt: x@y+1 put: (tm colorAt:xInTM@yInTM+1)]].
webmercator display. Display forceToScreen!

!GPSPosition methodsFor: 'accessing' stamp: 'jmv 3/3/2015 11:21'!
altitude
	"Altitude is in meters. 0.0 is the WGS 84 ellipsoid."
	^ self at: 3! !

!GPSPosition methodsFor: 'accessing' stamp: 'jmv 3/2/2015 13:34'!
height
	"Altitude is in meters. 0.0 is the WGS 84 ellipsoid."
	^ self at: 3! !

!GPSPosition methodsFor: 'accessing' stamp: 'jmv 3/2/2015 14:00'!
lambda
	"Longitude is in degrees, 0.0 is close to Greenwich. Positive values are east of Greenwich, negative values are west."
	^ self at: 2! !

!GPSPosition methodsFor: 'accessing' stamp: 'jmv 3/2/2015 13:34'!
latitude
	"Latitude is geodetic, in degrees. Positive values are north the equator, negative values are south."
	^ self at: 1! !

!GPSPosition methodsFor: 'accessing' stamp: 'jmv 3/2/2015 15:19'!
longitude
	"Longitude is in degrees, 0.0 is close to Greenwich. Positive values are east of Greenwich, negative values are west.
	Greenwich observatory is about 100 metres away from 0.0. 
	See http://www.thegreenwichmeridian.org/tgm/articles.php?article=7"
	^ self at: 2! !

!GPSPosition methodsFor: 'accessing' stamp: 'jmv 3/2/2015 14:00'!
phi
	"Latitude is geodetic, in degrees. Positive values are north the equator, negative values are south."
	^ self at: 1! !

!GPSPosition methodsFor: 'converting' stamp: 'jmv 9/18/2015 17:06'!
asECEF
	"Convert from geodetic coordinates to ECEF(also called ECF, called ECR by Landsat docs) Cartesian Coordinates.
	Answer is in meters
	http://en.wikipedia.org/wiki/Geodetic_datum#From_geodetic_to_ECEF
	https://microem.ru/files/2012/08/GPS.G1-X-00006.pdf
	http://earth-info.nga.mil/GandG/publications/tr8350.2/tr8350_2.htmlhttp://www.nalresearch.com/files/Standard%20Modems/A3LA-XG/A3LA-XG%20SW%20Version%201.0.0/GPS%20Technical%20Documents/GPS.G1-X-00006%20(Datum%20Transformations).pdf
	http://www.sage.unsw.edu.au/snap/gps/clynch_pdfs/coordcvt.pdf

	(GPSPosition latitude: -34.6 longitude: -58.4 altitude: 25) asECEF 
	Chequear con: http://www.oc.nps.edu/oc2902w/coord/llhxyz.htm o http://www.sysense.com/products/ecef_lla_converter/index.html
	
	(GPSPosition latitude: 45.19242321643 longitude: 0.0 altitude: 0.0) asECEF
	(GPSPosition latitude: 45.19242321643 longitude: 0.0 altitude: 0.0) asECEFSpherical

	(GPSPosition latitude: 45.0 longitude: 0.0 altitude: 0.0) asECEF
	(GPSPosition latitude: 45.0 longitude: 0.0 altitude: 0.0) asECEFSpherical
	"
	
	| h n x y z lambda phi a b |
	a _ GPSPosition wgs84SemiMajorAxis.
	b _ GPSPosition wgs84SemiMinorAxis.
	n _ GPSPosition normalAtLatitude: self phi.
	phi _ self phi degreesToRadians.
	lambda _ self lambda degreesToRadians.
	h _ self height.
	x _ (n + h) * phi cos * lambda cos.
	y _ (n + h) * phi cos * lambda sin.
	z _ (b squared / a squared * n + h) * phi sin.
	^ Float64Vector3 x: x y: y z: z! !

!GPSPosition methodsFor: 'converting' stamp: 'jmv 5/10/2021 13:28:20'!
asECEFSpherical
	"como asECEF, pero todo esferico.
	O sea, la latitud es geocentrica, no geodetica.
	En general, NO USAR. Casi nunca tiene sentido!!"
	
	| magnitude latitude longitude parallelCircleRadius x y z |
	magnitude _ GPSPosition wgs84SemiMajorAxis + self height.
	latitude _ self phi degreesToRadians.
	longitude _ self lambda degreesToRadians.
	parallelCircleRadius _ magnitude * latitude cos.
	x _ parallelCircleRadius * longitude cos.
	y _ parallelCircleRadius * longitude sin.
	z _ magnitude * latitude sin.
	^ Float64Vector3 x: x y: y z: z! !

!GPSPosition methodsFor: 'converting' stamp: 'jmv 9/30/2015 12:34'!
withHeight: h
	"
	Answer a new GPSPosition, with same latitude and longitude, and with requested height above the ellipsoid.
	(GPSPosition fromECEF: (GPSPosition latitude: 65 longitude: -151 altitude: 100) asECEF) withHeight: 200
	"
	^ self copy at: 3 put: h; yourself! !

!GPSPosition methodsFor: 'converting' stamp: 'jmv 9/30/2015 12:34'!
withZeroHeight
	"
	Answer a new GPSPosition, with same latitude and longitude, and with requested height above the ellipsoid.
	(GPSPosition fromECEF: (GPSPosition latitude: 65 longitude: -151 altitude: 100) asECEF) withZeroHeight
	"
	^ self withHeight: 0.0! !

!GPSPosition methodsFor: 'printing' stamp: 'jmv 12/2/2016 11:32:28'!
shortPrintString
	^String streamContents: [ :strm |
		strm nextPut: $(.
		self latitude printOn: strm fractionDigits: 5.
		strm nextPutAll: ','.
		self longitude printOn: strm fractionDigits: 5.
		strm nextPut: $) ]! !

!GPSPosition class methodsFor: 'instance creation' stamp: 'jmv 9/30/2015 09:01'!
fromECEF: aPoint3D
	"
	Por qu� todo el mundo habla de c�lculos iterativos? es que el c�lculo directo no es tan bueno por alg�n motivo???
	
	https://microem.ru/files/2012/08/GPS.G1-X-00006.pdf
	http://www.nalresearch.com/files/Standard%20Modems/A3LA-XG/A3LA-XG%20SW%20Version%201.0.0/GPS%20Technical%20Documents/GPS.G1-X-00006%20(Datum%20Transformations).pdf
	http://www.sage.unsw.edu.au/snap/gps/clynch_pdfs/coordcvt.pdf
	http://www.satsleuth.com/GPS_ECEF_Datum_transformation.htm

	GPSPosition fromECEF: (GPSPosition latitude: -34.6 longitude: -58.4 altitude: 25) asECEF
	Check against: http://www.oc.nps.edu/oc2902w/coord/llhxyz.htm o http://www.sysense.com/products/ecef_lla_converter/index.html
	
	GPSPosition fromECEF: (GPSPosition latitude: 65 longitude: -151 altitude: 0) asECEF.
	GPSPosition fromECEF: (GPSPosition latitude: 65 longitude: 151 altitude: 0) asECEF.
	GPSPosition fromECEF: (GPSPosition latitude: -65 longitude: 151 altitude: 0) asECEF.
	GPSPosition fromECEF: 0 @ 0 @ 6356752.31.
	GPSPosition fromECEF: 1 @ 0 @ 6356752.31.
	GPSPosition fromECEF: 0 @ 0 @ 0.
	GPSPosition fromECEF: 1 @ 0 @ 0.
	"

	| h lambda phi a b distanceToZAxis theta ePrimeSquared eSquared normalDistanceToZ |
	distanceToZAxis _ (aPoint3D x squared + aPoint3D y squared) sqrt.
	b _ self wgs84SemiMinorAxis.
	distanceToZAxis > 0.0
		ifTrue: [		"aPoint3D is not along the Earth rotation axis. Not at the North or South pole."
			lambda _ aPoint3D y arcTan: aPoint3D x.
			a _ self wgs84SemiMajorAxis.
			theta _ (aPoint3D z * a / (distanceToZAxis * b)) arcTan.
			eSquared _ self wgs84FirstEccentricitySquared.
			ePrimeSquared _ self wgs84SecondEccentricitySquared.
			phi _ ((aPoint3D z + (ePrimeSquared * b * theta sin cubed)) / ( distanceToZAxis - (eSquared * a * theta cos cubed))) arcTan.
			normalDistanceToZ _ GPSPosition normalAtLatitude: phi radiansToDegrees.
			h _ distanceToZAxis / phi cos - normalDistanceToZ ]
		ifFalse: [ 	"aPoint3D IS along the Earth rotation axis. We are at North or South pole (at some positive or negative altitude wrt. the WGS84 ellipsoid)."
			lambda _ 0.0.
			phi _ aPoint3D z sign * Float halfPi.
			h _ aPoint3D z abs - b ].
	^GPSPosition latitude: phi radiansToDegrees longitude: lambda radiansToDegrees altitude: h! !

!GPSPosition class methodsFor: 'instance creation' stamp: 'jmv 1/22/2016 11:46'!
fromECEFSpherical: aPoint3D
	"como fromECEF: pero todo esferico.
	O sea, la latitud es geocentrica, no geodetica.
	En general, NO USAR. Casi nunca tiene sentido!!"

	| distanceToZAxis h latitude longitude |
	distanceToZAxis _ (aPoint3D x squared + aPoint3D y squared) sqrt.
	latitude _ aPoint3D z arcTan: distanceToZAxis.
	longitude _ aPoint3D y arcTan: aPoint3D x.
	h _ aPoint3D length - self wgs84SemiMajorAxis.
	^GPSPosition latitude: latitude radiansToDegrees longitude: longitude radiansToDegrees altitude: h! !

!GPSPosition class methodsFor: 'instance creation' stamp: 'jmv 3/3/2015 16:16'!
latitude: phi longitude: lambda altitude: h
	"
	GPSPosition latitude: -34.6 longitude: -58.4 altitude: 25
	" 
	^self new
		at: 1 put: phi;
		at: 2 put: lambda;
		at: 3 put: h;
		yourself! !

!GPSPosition class methodsFor: 'instance creation' stamp: 'jmv 8/9/2018 16:51:22'!
latitudeDegrees: latDeg minutes: latMin seconds: latSec longitudeDegrees: lonDeg minutes: lonMin seconds: lonSec

	^ self
		latitude: latSec/60.0+latMin / 60.0 + latDeg
		longitude: lonSec/60.0+lonMin / 60.0 + lonDeg
		altitude: 0.0! !

!GPSPosition class methodsFor: 'instance creation' stamp: 'jmv 4/7/2015 15:04'!
longitude: lambda latitude: phi altitude: h
	^ self latitude: phi longitude: lambda altitude: h! !

!GPSPosition class methodsFor: 'instance creation' stamp: 'jmv 3/2/2015 13:21'!
numElements
	^3! !

!GPSPosition class methodsFor: 'aux functions' stamp: 'jmv 5/10/2021 13:28:26'!
normalAtLatitude: phi
	"Distance from the surface to the Z-axis along the ellipsoid normal
	http://en.wikipedia.org/wiki/Geodetic_datum
	GPSPosition earthRadiusAtLatitude: 90 6.39959362575849e6
	GPSPosition earthRadiusAtLatitude: 0 6.378137e6
	" 
	| a eSquared |
	a _ self wgs84SemiMajorAxis.
	eSquared _ self wgs84FirstEccentricitySquared.
	^ a / (1 - (eSquared * phi degreesToRadians sin squared)) sqrt! !

!GPSPosition class methodsFor: 'constants' stamp: 'jmv 3/2/2015 15:58'!
wgs84FirstEccentricitySquared
	"
	GPSPosition wgs84FirstEccentricitySquared
	http://earth-info.nga.mil/GandG/publications/tr8350.2/tr8350_2.htmlhttp://www.nalresearch.com/files/Standard%20Modems/A3LA-XG/A3LA-XG%20SW%20Version%201.0.0/GPS%20Technical%20Documents/GPS.G1-X-00006%20(Datum%20Transformations).pdf
	http://www.satsleuth.com/GPS_ECEF_Datum_transformation.htm
	http://en.wikipedia.org/wiki/Geodetic_datum
	http://earth-info.nga.mil/GandG/publications/tr8350.2/tr8350_2.html
	called e^2
	"
	"^ 6.69437999014e-3"
	| a b |
	a _ self wgs84SemiMajorAxis.
	b _ self wgs84SemiMinorAxis.
	^a squared - b squared / a squared! !

!GPSPosition class methodsFor: 'constants' stamp: 'jmv 3/2/2015 15:57'!
wgs84RecipfocalOfFlattening
	"http://en.wikipedia.org/wiki/Geodetic_datum
	http://earth-info.nga.mil/GandG/publications/tr8350.2/tr8350_2.htmlhttp://www.nalresearch.com/files/Standard%20Modems/A3LA-XG/A3LA-XG%20SW%20Version%201.0.0/GPS%20Technical%20Documents/GPS.G1-X-00006%20(Datum%20Transformations).pdf
	called 1/f
	"
	^ 298.257223563! !

!GPSPosition class methodsFor: 'constants' stamp: 'jmv 3/2/2015 15:57'!
wgs84SecondEccentricitySquared
	"
	GPSPosition wgs84SecondEccentricitySquared
	http://www.satsleuth.com/GPS_ECEF_Datum_transformation.htm
	http://www.nalresearch.com/files/Standard%20Modems/A3LA-XG/A3LA-XG%20SW%20Version%201.0.0/GPS%20Technical%20Documents/GPS.G1-X-00006%20(Datum%20Transformations).pdf
	http://en.wikipedia.org/wiki/Geodetic_datum
	http://earth-info.nga.mil/GandG/publications/tr8350.2/tr8350_2.html
	called e'^2
	"
	"^ 6.73949674228e-3"
	| a b |
	a _ self wgs84SemiMajorAxis.
	b _ self wgs84SemiMinorAxis.
	^a squared - b squared / b squared! !

!GPSPosition class methodsFor: 'constants' stamp: 'jmv 3/2/2015 15:57'!
wgs84SemiMajorAxis
	"
	http://www.satsleuth.com/GPS_ECEF_Datum_transformation.htm
	http://www.nalresearch.com/files/Standard%20Modems/A3LA-XG/A3LA-XG%20SW%20Version%201.0.0/GPS%20Technical%20Documents/GPS.G1-X-00006%20(Datum%20Transformations).pdf
	http://en.wikipedia.org/wiki/Geodetic_datum
	http://earth-info.nga.mil/GandG/publications/tr8350.2/tr8350_2.html
	called a
	In metres
	"
	^ 6378137.0 "m"! !

!GPSPosition class methodsFor: 'constants' stamp: 'jmv 3/2/2015 15:57'!
wgs84SemiMinorAxis
	"
	http://www.satsleuth.com/GPS_ECEF_Datum_transformation.htm
	http://www.nalresearch.com/files/Standard%20Modems/A3LA-XG/A3LA-XG%20SW%20Version%201.0.0/GPS%20Technical%20Documents/GPS.G1-X-00006%20(Datum%20Transformations).pdf
	http://en.wikipedia.org/wiki/Geodetic_datum
	http://earth-info.nga.mil/GandG/publications/tr8350.2/tr8350_2.html
	called b
	In metres
	"
	^ 6356752.3142 "m"! !

!GPSPosition class methodsFor: 'constants' stamp: 'jmv 3/2/2015 15:57'!
wgsFlattening
	"
	GPSPosition wgsFlattening
	http://www.satsleuth.com/GPS_ECEF_Datum_transformation.htm
	http://www.nalresearch.com/files/Standard%20Modems/A3LA-XG/A3LA-XG%20SW%20Version%201.0.0/GPS%20Technical%20Documents/GPS.G1-X-00006%20(Datum%20Transformations).pdf
	"
	| a b |
	a _ self wgs84SemiMajorAxis.
	b _ self wgs84SemiMinorAxis.
	^a-b / a! !

!WebmercatorProjection methodsFor: 'conversion' stamp: 'jmv 8/13/2018 14:01:54'!
latLongFromMapPosition: aPoint
	"
	x and y go from 0.0 to 1.0
	WebmercatorProjection new latLongFromMapPosition:(WebmercatorProjection new mapPositionFromLatLong: (GPSPosition latitude: -34.6 longitude: -58.4 altitude: 25))
	WebmercatorProjection new latLongFromMapPosition:(WebmercatorProjection new mapPositionFromLatLong: (GPSPosition latitude: 0.0 longitude: 0.0 altitude: 0.0))
	WebmercatorProjection new latLongFromMapPosition:(WebmercatorProjection new mapPositionFromLatLong: (GPSPosition latitude: 0.0 longitude: -180.0 altitude: 0.0))
	WebmercatorProjection new latLongFromMapPosition:(WebmercatorProjection new mapPositionFromLatLong: (GPSPosition latitude: 0.0 longitude: 180.0 altitude: 0.0))
	WebmercatorProjection new latLongFromMapPosition:(WebmercatorProjection new mapPositionFromLatLong: (GPSPosition latitude: 85.051129 longitude: 0.0 altitude: 0.0))
	WebmercatorProjection new latLongFromMapPosition:(WebmercatorProjection new mapPositionFromLatLong: (GPSPosition latitude: -85.051129 longitude: 0.0 altitude: 0.0))
	WebmercatorProjection new latLongFromMapPosition:(WebmercatorProjection new mapPositionFromLatLong: (GPSPosition latitude: 66.51326 longitude: 0.0 altitude: 0.0))
	WebmercatorProjection new latLongFromMapPosition:(WebmercatorProjection new mapPositionFromLatLong: (GPSPosition latitude: -66.51326 longitude: 0.0 altitude: 0.0))
	"
	
	| lambda phi |
	lambda _ aPoint x  * 2 * Float pi - Float pi.
	phi _ ((Float e raisedTo: (Float pi - (2 * Float pi * aPoint y))) arcTan - (Float pi / 4)) * 2.
	^ GPSPosition latitude: phi radiansToDegrees longitude: lambda radiansToDegrees altitude: 0.! !

!WebmercatorProjection methodsFor: 'conversion' stamp: 'jmv 8/13/2018 14:08:25'!
mapPositionFromLat: latitude long: longitude
	"
	x and y go from 0.0 to 1.0
	" 
	| x y pi |
	pi _ Float pi.
	x _ 0.5 / pi * (longitude degreesToRadians + pi).
	y _ 0.5 / pi * ( pi - (pi / 4 + (latitude degreesToRadians/2.0)) tan ln ).
	^ x@y! !

!WebmercatorProjection methodsFor: 'conversion' stamp: 'jmv 8/13/2018 14:08:47'!
mapPositionFromLatLong: aGPSPosition
	"
	x and y go from 0.0 to 1.0
	WebmercatorProjection new mapPositionFromLatLong: (GPSPosition latitude: -34.6 longitude: -58.4 altitude: 25)
	WebmercatorProjection new mapPositionFromLatLong: (GPSPosition latitude: 0.0 longitude: 0.0 altitude: 0.0)
	WebmercatorProjection new mapPositionFromLatLong: (GPSPosition latitude: 0.0 longitude: -180.0 altitude: 0.0)
	WebmercatorProjection new mapPositionFromLatLong: (GPSPosition latitude: 0.0 longitude: 180.0 altitude: 0.0)
	WebmercatorProjection new mapPositionFromLatLong: (GPSPosition latitude: 85.051129 longitude: 0.0 altitude: 0.0)
	WebmercatorProjection new mapPositionFromLatLong: (GPSPosition latitude: -85.051129 longitude: 0.0 altitude: 0.0)
	WebmercatorProjection new mapPositionFromLatLong: (GPSPosition latitude: 66.51326 longitude: 0.0 altitude: 0.0)
	WebmercatorProjection new mapPositionFromLatLong: (GPSPosition latitude: -66.51326 longitude: 0.0 altitude: 0.0)
	" 
	^ self mapPositionFromLat: aGPSPosition latitude long: aGPSPosition longitude! !

!WebmercatorProjection methodsFor: 'services' stamp: 'jmv 8/17/2018 16:21:15'!
gsdAtLatitude: latitudeDegrees zoomLevel: aZoomLevel
	"Answer an approximate GSD in meters at latitudeDegrees for aZoomLevel.
	It is approximate because it is not really constant!!
	WebmercatorProjection  new gsdAtLatitude: 33.144 zoomLevel: 17
	"
	| gsdAtEquator gsdAtLatitude |
	gsdAtEquator _ GPSPosition wgs84SemiMajorAxis * Float twoPi / 256 / (2 raisedToInteger: aZoomLevel).
	gsdAtLatitude _ (gsdAtEquator * latitudeDegrees degreesToRadians cos).
	^ gsdAtLatitude

"Play with this:"
"zoomLevel _ 19.
gsdAtEquator _ GPSPosition wgs84SemiMajorAxis * Float twoPi / 256 / (2 raisedToInteger: zoomLevel).
latitude _ 43.

base _ GPSPosition latitude: latitude longitude: 0 altitude: 0.
inMap _ (WebmercatorProjection new mapPositionFromLatLong: base) * (2 raisedToInteger: zoomLevel) * 256.
oneToTheEast _ inMap + (1@0).
oneToTheWest _ inMap - (1@0).
oneToTheSouth _ inMap + (0@1).
oneToTheNorth _ inMap - (0@1).

'-----' print.
gsdAtLat _ (gsdAtEquator * latitude degreesToRadians cos) print.
((WebmercatorProjection new latLongFromMapPosition: oneToTheEast / (2 raisedToInteger: zoomLevel) / 256) asECEF - base asECEF) length print.
((WebmercatorProjection new latLongFromMapPosition: oneToTheWest / (2 raisedToInteger: zoomLevel) / 256) asECEF - base asECEF) length print.
((WebmercatorProjection new latLongFromMapPosition: oneToTheSouth / (2 raisedToInteger: zoomLevel) / 256) asECEF - base asECEF) length print.
((WebmercatorProjection new latLongFromMapPosition: oneToTheNorth / (2 raisedToInteger: zoomLevel) / 256) asECEF - base asECEF) length print.
nil.
"! !

!WebmercatorProjection methodsFor: 'services' stamp: 'jmv 8/17/2018 16:28:15'!
minZoomLevelForGsd: desiredGSDmeters latitude: latitudeDegrees
	"Answer the minimum zoom level to be used to use tiles of desiredGSDmeters or better, at specified latitude."

	| tileGSDmetersZoomZero zoom |
	tileGSDmetersZoomZero _ self gsdAtLatitude: latitudeDegrees zoomLevel: 0.
	zoom _ (tileGSDmetersZoomZero / desiredGSDmeters) log2 ceiling.
	^ zoom! !
