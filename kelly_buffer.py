import numpy
import math
from scipy.spatial import distance

lines = open('H:/GIS_projects/2015_Y/Nk_test/nick_8202015/n_08202015_preprocess_out.csv').readlines()


plots = []
for i in range(1,20): #row
    for j in range(1,99): #column
        plots.append('p%02d_%01d' % (i,j))
print(plots)

f = open('H:/GIS_projects/2015_Y/Nk_test/nick_8202015/n_08202015_buffer_process_out.csv','w')
f.write('Plot,ULX,ULY,URX,URY,LRX,LRY,LLX,LLY\n')
f1 = open('H:/GIS_projects/2015_N/temppoints.csv','w')
f1.write('UTMX,UTMY\n')

points = []
for p in plots:
    points[:] = []
    for line in lines[1:]:
        line = line.rstrip().split(',')
        if line[3] == p:
            points.append([float(line[4]),float(line[5])])
            if len(points) == 4:
                break
    pts = numpy.array(points)
    pts = pts[pts[:,0].argsort()]
    print(p)
    print(pts)
    
    ll = pts[0]
    ul = pts[1]
    lr = pts[2]
    ur = pts[3]
    
    #https://stackoverflow.com/questions/1401712/how-can-the-euclidean-distance-be-calculated-with-numpy
    #https://math.stackexchange.com/questions/175896/finding-a-point-along-a-line-a-certain-distance-away-from-another-point
       
    adj1 = 0.1 #meters
    #New north edge points
    dst = distance.euclidean(ul,ur)
    t = adj1/dst
    p1 = numpy.array([(1-t)*ul[0]+t*ur[0],(1-t)*ul[1]+t*ur[1]])
    t = (dst-adj1)/dst
    p2 = numpy.array([(1-t)*ul[0]+t*ur[0],(1-t)*ul[1]+t*ur[1]])
    
    #New south edge points
    dst = distance.euclidean(ll,lr)
    t = adj1/dst
    p3 = numpy.array([(1-t)*ll[0]+t*lr[0],(1-t)*ll[1]+t*lr[1]])
    t = (dst-adj1)/dst
    p4 = numpy.array([(1-t)*ll[0]+t*lr[0],(1-t)*ll[1]+t*lr[1]])
    
    adj2 = 0.3 #meters
    dst = distance.euclidean(p1,p3)
    t = adj2/dst
    ulnew = [(1-t)*p1[0]+t*p3[0],(1-t)*p1[1]+t*p3[1]]
    t = (dst-adj2)/dst
    llnew = [(1-t)*p1[0]+t*p3[0],(1-t)*p1[1]+t*p3[1]]
    dst = distance.euclidean(p2,p4)
    t = adj2/dst
    urnew = [(1-t)*p2[0]+t*p4[0],(1-t)*p2[1]+t*p4[1]]
    t = (dst-adj2)/dst
    lrnew = [(1-t)*p2[0]+t*p4[0],(1-t)*p2[1]+t*p4[1]]
 
    f.write(p + ',')
    f.write(str(ulnew[0]) + ',' + str(ulnew[1]) + ',')
    f.write(str(urnew[0]) + ',' + str(urnew[1]) + ',')
    f.write(str(lrnew[0]) + ',' + str(lrnew[1]) + ',')
    f.write(str(llnew[0]) + ',' + str(llnew[1]) + '\n')
    
    f1.write(str(p1[0]) + ',' + str(p1[1]) + '\n')
    f1.write(str(p2[0]) + ',' + str(p2[1]) + '\n')
    f1.write(str(p3[0]) + ',' + str(p3[1]) + '\n')
    f1.write(str(p4[0]) + ',' + str(p4[1]) + '\n')
    
f.close()
f1.close()
