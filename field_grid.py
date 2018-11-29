# Field Splitter Tool
#
# Use: Splits a 4 point polygon into a series of row and column polygons.
# 
# Instructions: Set the 6 variables below, open QGIS, select input polygon layer, use ScriptRunner plugin (or equivalent) to run script.
# 
# Note: Direction of ids depends on order of polygon points.  The starting corner is the last point in the polygon.
#
# Author: James W. Clohessy
# Email: jameswclohessy@gmail.com

import math
from PyQt4.QtCore import *
from PyQt4.QtGui import *
from qgis.core import *
from qgis.gui import *

def run_script(iface):

	##### SET VARIABLES HERE ###################
	
	numrows = 45 # SET NUMBER OF ROWS HERE
	numcols = 56 # SET NUMBER OF COLUMNS HERE

	column = 1 # SET COLUMN NUMBER START HERE
	row = 1 # SET ROW NUMBER START HERE
	
	positiveColumnDirection = 1 # SET TRUE (1) IF COLUMN NUMBER ADVANCES FORWARD, FALSE (0) IF WE NEED TO DECREMENT THE COLUMN NUMBER COUNTER
	positiveRowDirection = 1 # SET TRUE (1) IF ROW NUMBER ADVANCES FORWARD, FALSE (0) IF WE NEED TO DECREMENT THE ROW NUMBER COUNTER

	###### END SET VARIABLES ##################
	
	
	#Uses the currently selected layer in QGIS
	fieldLayer = iface.activeLayer()
	fieldFeatures = fieldLayer.getFeatures()

	#Initialize a new polygon layer in memory
	crs = fieldLayer.crs().toWkt()
	rowLayer =  QgsVectorLayer('Polygon?crs='+crs, 'Rows' , "memory")
	rowProvider = rowLayer.dataProvider()
	rowProvider.addAttributes([QgsField('rowNum', QVariant.Int)])
	rowLayer.commitChanges()
	rowLayer.updateFields()


	#Initialize a new polygon layer in memory
	crs = fieldLayer.crs().toWkt()
	columnLayer =  QgsVectorLayer('Polygon?crs='+crs, 'Columns' , "memory")
	columnProvider = columnLayer.dataProvider()
	columnProvider.addAttributes([QgsField('columnNum', QVariant.Int)])
	columnLayer.commitChanges()
	columnLayer.updateFields()

	
	#Iterate through every plot in the source layer
	for fieldFeature in fieldFeatures:
		thisField = fieldFeature.geometry().asPolygon()
		
		startPoint = thisField[0][1]
		#find the long side adjacent to the point
		if (distance(startPoint,thisField[0][0]) > distance(startPoint,thisField[0][2])):
			destinationPoint = thisField[0][0]
			otherSidePoint = thisField[0][2]
		else:
			destinationPoint = thisField[0][2]
			otherSidePoint = thisField[0][0]

		farPoint = thisField[0][3]

		plotWidthDeltaX = (startPoint.x()-destinationPoint.x())/numcols
		plotWidthDeltaY = (startPoint.y()-destinationPoint.y())/numcols
		plotWidthDeltaX2 = (otherSidePoint.x()-farPoint.x())/numcols
		plotWidthDeltaY2 = (otherSidePoint.y()-farPoint.y())/numcols

		for plotNum in range(numcols):
				
			#create a new feature
			columnFeature = QgsFeature()

			bottomStart = QgsPoint(startPoint.x()-(plotNum*plotWidthDeltaX), startPoint.y()-(plotNum*plotWidthDeltaY))
			bottomEnd= QgsPoint(otherSidePoint.x()-(plotNum*plotWidthDeltaX2), otherSidePoint.y()-(plotNum*plotWidthDeltaY2))

			topStart = QgsPoint(startPoint.x()-((plotNum+1)*plotWidthDeltaX), startPoint.y()-((plotNum+1)*plotWidthDeltaY))
			topEnd= QgsPoint(otherSidePoint.x()-((plotNum+1)*plotWidthDeltaX2), otherSidePoint.y()-((plotNum+1)*plotWidthDeltaY2))

			#create the polygon geometry
			columnPoints = [topStart,topEnd,bottomEnd,bottomStart]
			columnGeometry = QgsGeometry.fromPolygon([columnPoints])
			columnFeature.initAttributes(1)
			columnFeature.setGeometry(columnGeometry)
			columnFeature[0]=column
			columnProvider.addFeatures([columnFeature])
			
			if (positiveColumnDirection):
				column = column + 1
			else:
				column = column - 1

		columnLayer.updateExtents()
		QgsMapLayerRegistry.instance().addMapLayers([columnLayer])


		startPoint = thisField[0][1]
		#find the short side adjacent to the point
		if (distance(startPoint,thisField[0][0]) > distance(startPoint,thisField[0][2])):
			otherSidePoint = thisField[0][0]
			destinationPoint = thisField[0][2]
		else:
			otherSidePoint = thisField[0][2]
			destinationPoint = thisField[0][0]

		farPoint = thisField[0][3]

		plotHeightDeltaX = (startPoint.x()-destinationPoint.x())/numrows
		plotHeightDeltaY = (startPoint.y()-destinationPoint.y())/numrows
		plotHeightDeltaX2 = (otherSidePoint.x()-farPoint.x())/numrows
		plotHeightDeltaY2 = (otherSidePoint.y()-farPoint.y())/numrows

		for plotNum in range(numrows):
					
			#create a new feature
			rowFeature = QgsFeature()

			bottomStart = QgsPoint(startPoint.x()-(plotNum*plotHeightDeltaX), startPoint.y()-(plotNum*plotHeightDeltaY))
			bottomEnd= QgsPoint(otherSidePoint.x()-(plotNum*plotHeightDeltaX2), otherSidePoint.y()-(plotNum*plotHeightDeltaY2))

			topStart = QgsPoint(startPoint.x()-((plotNum+1)*plotHeightDeltaX), startPoint.y()-((plotNum+1)*plotHeightDeltaY))
			topEnd= QgsPoint(otherSidePoint.x()-((plotNum+1)*plotHeightDeltaX2), otherSidePoint.y()-((plotNum+1)*plotHeightDeltaY2))

			#create the polygon geometry
			rowPoints = [topStart,topEnd,bottomEnd,bottomStart]
			rowGeometry = QgsGeometry.fromPolygon([rowPoints])
			rowFeature.initAttributes(1)
			rowFeature.setGeometry(rowGeometry)
			rowFeature[0]=row
			rowProvider.addFeatures([rowFeature])
			
			if (positiveRowDirection):
				row = row + 1
			else:
				row = row - 1

		rowLayer.updateExtents()
		QgsMapLayerRegistry.instance().addMapLayers([rowLayer])

def distance(point1,point2):
    return math.sqrt((point2.x()-point1.x())**2 + (point2.y()-point1.y())**2)
