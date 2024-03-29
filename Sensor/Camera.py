from Brain.Robot_ball_distance import ball_distance

import cv2
import numpy as np
import time
from PIL import Image
from imutils.video import WebcamVideoStream
from imutils.video import FPS

class Camera:
    def __init__(self):
        # 카메라 설정
        self.lowerLimitP = np.array([116, 40, 103], dtype=np.uint8)
        self.upperLimitP = np.array([179, 255, 255], dtype=np.uint8)

        self.lowerLimitH = np.array([0, 44, 17], dtype=np.uint8)
        self.upperLimitH = np.array([14, 255, 255], dtype=np.uint8)

        self.shotZone = [500, 600]
        # cv2.line(filtered_frame, (310,0), (550,480), (0,0,255), 2) => y = 2x - 620
        # cv2.line(filtered_frame, (335,0), (640,380), (0,0,255), 2) => 76x- 61y = 25460 => y = 76x-25460/61
        
        
        self.cam = WebcamVideoStream(-1).start()
        self.fps = FPS()
        shape = (self.height, self.width, _) = self.get_image().shape
        print(shape) # 세로, 가로 출력
        time.sleep(2)

    
    # 이미지 공급 쓰레드에서 이미지 하나 get.    
    def get_image(self):
        try:
            print("image get")
            return self.cam.read()
        except AttributeError: # 이미지를 얻지 못할경우 검은화면 반환
            print("Attribute Error")
            return np.zeros(shape=(480, 640, 3), dtype="uint8")
    
    # hsv 허용 범위 설정
    def hsv_limits(color):
        c = np.uint8([[color]])
        hsvC = cv2.cvtColor(c, cv2.COLOR_BGR2HSV)
        
        lowerLimit = hsvC[0][0][0] - 10, 100, 100
        upperLimit = hsvC[0][0][0] + 10, 255, 255
        
        lowerLimit = np.array(lowerLimit, dtype=np.uint8)
        upperLimit = np.array(upperLimit, dtype=np.uint8)
        
        return lowerLimit, upperLimit
    
    def hsvDetect(self, img):
        hsvImg = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
        mask1 = cv2.inRange(hsvImg, self.lowerLimitP, self.upperLimitP)
        mask2 = cv2.inRange(hsvImg, self.lowerLimitH, self.upperLimitH)
        mask = cv2.bitwise_or(mask1, mask2)
        num_labels, labels, stats, centroids = cv2.connectedComponentsWithStats(mask, connectivity=8)
        max_area = -1
        max_density = -1
        max_area_idx = -1
        # 노이즈를 잡기 위한 최소한의 밀집도
        min_density = 0.5  # 예시: 50% 이상의 픽셀이 1이어야 함

        for i in range(1, num_labels):  # 0번은 배경이므로 무시합니다.
            area = stats[i,cv2.CC_STAT_AREA]
            density = stats[i, cv2.CC_STAT_AREA] / (stats[i, cv2.CC_STAT_WIDTH] * stats[i, cv2.CC_STAT_HEIGHT])

            if density > min_density and area > max_area:
                max_area = area
                max_area_idx = i
        if max_area < 10:
                max_area_idx = -1
        if max_area_idx != -1:
            x1, y1, w, h, _ = stats[max_area_idx]
            x2, y2 = x1 + w, y1 + h
            # img = cv2.rectangle(img, (x1, y1), (x2, y2), (0, 255, 0), 4)
            return True, (x1, y1), (x2, y2)
        return False, (False, False), (False, False)
    
    # 홀 인식
    def is_hole(self, img):
        mask = self.preprocess(img)

        detector = cv2.SimpleBlobDetector_create() # 개체 검출 객체 생성
        params = cv2.SimpleBlobDetector_Params()   # 파라미터 설정 객체(크기, 원형도, 관성 비율)

        # Area
        params.filterByArea = True
        params.minArea = 90  # 최소 홀 크기
        params.maxArea = 500000000  # 최대 홀 크기

        # Circularity
        params.filterByCircularity = True
        params.minCircularity = 0.1  # 최소 원형도

        # Convexity
        params.filterByConvexity = True
        params.minConvexity = 0.03

        # Inertia
        params.filterByInertia = True
        params.minInertiaRatio = 0.0000001  # 최소 관성 비율

        # Blob 간의 거리 설정
        params.minDistBetweenBlobs = 100000

        # 파라미터
        detector = cv2.SimpleBlobDetector_create(params)

        keypoints = detector.detect(mask) # mask된 이미지에서 hole의 위치 및 특성 검출
        
        ret = False
        detected_points = [False, False]
        for k in keypoints:
            ret = True
            detected_points = (int(k.pt[0]), int(k.pt[1]))
            return ret, detected_points
            
        return ret, detected_points
    
    # hall detect v2
    def holeDetect(self, img):
        mask = self.preprocess(img)
        # cv2.imshow("Frame", mask)
        # cv2.waitKey(1)
        num_labels, labels, stats, centroids = cv2.connectedComponentsWithStats(mask, connectivity=8)
        max_area = -1
        max_area_idx = -1
        # 노이즈를 잡기 위한 최소한의 밀집도
        min_density = 0.1  # 예시: 50% 이상의 픽셀이 1이어야 함

        for i in range(1, num_labels):  # 0번은 배경이므로 무시합니다.
            area = stats[i,cv2.CC_STAT_AREA]
            density = stats[i, cv2.CC_STAT_AREA] / (stats[i, cv2.CC_STAT_WIDTH] * stats[i, cv2.CC_STAT_HEIGHT])
            x, y, w, h, _ = stats[i]
            dist = y + h
            
            if density > min_density and area > 30 and area > max_area:
                max_area = area
                max_area_idx = i
        if max_area_idx != -1:
            x1, y1, w, h, _ = stats[max_area_idx]
            x, y = x1 + w/2, y1 + h/2
            # img = cv2.rectangle(img, (x1, y1), (x2, y2), (0, 255, 0), 4)
            return True, int(x), int(y)
        return False, False, False
    
    def holeDetect_far(self, img):
        mask = self.preprocess(img)
        num_labels, labels, stats, centroids = cv2.connectedComponentsWithStats(mask, connectivity=8)
        max_area = -1
        max_dist_idx = -1
        max_dist = 1000
        # 노이즈를 잡기 위한 최소한의 밀집도
        min_density = 0.1  # 예시: 50% 이상의 픽셀이 1이어야 함

        for i in range(1, num_labels):  # 0번은 배경이므로 무시합니다.
            area = stats[i,cv2.CC_STAT_AREA]
            density = stats[i, cv2.CC_STAT_AREA] / (stats[i, cv2.CC_STAT_WIDTH] * stats[i, cv2.CC_STAT_HEIGHT])
            x, y, w, h, _ = stats[i]
            dist = y + h
            if density > min_density and area > 5 and dist < max_dist:
                max_dist = dist
                max_dist_idx = i
        if max_dist_idx != -1:
            x1, y1, w, h, _ = stats[max_dist_idx]
            x, y = x1 + w/2, y1 + h
            # img = cv2.rectangle(img, (x1, y1), (x2, y2), (0, 255, 0), 4)
            return True, int(x), int(y)
        return False, False, False
    
    def holeDetect_close(self, img):
        mask = self.preprocess(img)
        # cv2.imshow("Frame", mask)
        # cv2.waitKey(1)
        num_labels, labels, stats, centroids = cv2.connectedComponentsWithStats(mask, connectivity=8)
        max_area = -1
        min_dist_idx = -1
        min_dist = -1
        # 노이즈를 잡기 위한 최소한의 밀집도
        min_density = 0.1  # 예시: 50% 이상의 픽셀이 1이어야 함

        for i in range(1, num_labels):  # 0번은 배경이므로 무시합니다.
            area = stats[i,cv2.CC_STAT_AREA]
            density = stats[i, cv2.CC_STAT_AREA] / (stats[i, cv2.CC_STAT_WIDTH] * stats[i, cv2.CC_STAT_HEIGHT])
            x, y, w, h, _ = stats[i]
            dist = y + h
            if density > min_density and area > 10 and dist > min_dist:
                min_dist = dist
                min_dist_idx = i
        if min_dist_idx != -1:
            x1, y1, w, h, _ = stats[min_dist_idx]
            x, y = x1 + w/2, y1 + h
            # img = cv2.rectangle(img, (x1, y1), (x2, y2), (0, 255, 0), 4)
            return True, int(x), int(y)
        return False, False, False
    
    def holeDetect_center(self, img):
        mask = self.preprocess(img)
        # cv2.imshow("Frame", mask)
        # cv2.waitKey(1)
        num_labels, labels, stats, centroids = cv2.connectedComponentsWithStats(mask, connectivity=8)
        max_area = -1
        max_area_idx = -1
        # 노이즈를 잡기 위한 최소한의 밀집도
        min_density = 0.1  # 예시: 50% 이상의 픽셀이 1이어야 함

        for i in range(1, num_labels):  # 0번은 배경이므로 무시합니다.
            area = stats[i,cv2.CC_STAT_AREA]
            density = stats[i, cv2.CC_STAT_AREA] / (stats[i, cv2.CC_STAT_WIDTH] * stats[i, cv2.CC_STAT_HEIGHT])
            x, y, w, h, _ = stats[i]
            dist = y + h
            if density > min_density and area > 8000 and area > max_area:
                max_area = area
                max_area_idx = i
        if max_area_idx != -1:
            x1, y1, w, h, _ = stats[max_area_idx]
            x, y = x1 + w/2, y1 + h/2
            # img = cv2.rectangle(img, (x1, y1), (x2, y2), (0, 255, 0), 4)
            return True, (int(x), int(y))
        return False, (False, False)
        
    def preprocess(self,img):
        lower_yellow = np.array([19, 105, 0])
        upper_yellow = np.array([42, 255, 255])
        hsvImg = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
        yellow_mask = cv2.inRange(hsvImg, lower_yellow, upper_yellow)


        return yellow_mask
    
    def find_tip(self, points, convex_hull):
        length = len(points)
        indices = np.setdiff1d(range(length), convex_hull)

        for i in range(2):
            j = indices[i] + 2
            if j > length - 1:
                j = length - j
            if np.all(points[j] == points[indices[i - 1] - 2]):
                return tuple(points[j])  
        
    
    def is_arrow(self, img):
        contours, hierarchy = cv2.findContours(self.preprocess(img), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
        '''
        leftmost = (float('inf'), float('inf'))
        rightmost = (float('-inf'), float('-inf'))
        topmost = (float('inf'), float('inf'))
        bottommost = (float('-inf'), float('-inf'))
        '''
        for cnt in contours:
            peri = cv2.arcLength(cnt, True)
            approx = cv2.approxPolyDP(cnt, 0.025 * peri, True)
            hull = cv2.convexHull(approx, returnPoints=False)
            sides = len(hull)

            if 15 > sides > 3 and sides + 2 == len(approx):
                arrow_tip = self.find_tip(approx[:,0,:], hull.squeeze())
                if arrow_tip:
                    #cv2.drawContours(img, [cnt], -1, (0, 255, 0), 3)
                    #cv2.circle(img, arrow_tip, 3, (0, 0, 255), cv2.FILLED)
                    return True, arrow_tip
        return False, [False,False]
        
    
    # 벙커 인식
    def is_bunker(self, img):
        lower_bound = np.array([0, 135, 0])
        upper_bound = np.array([180, 255, 31])

        mask = cv2.inRange(img, lower_bound, upper_bound)

        contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

        ret = False
        leftmost_point = None
        rightmost_point = None

        if len(contours) > 0:
            ret = True
            contour = contours[0]
            x, y, w, h = cv2.boundingRect(contour)
            if leftmost_point is None or x < leftmost_point[0]:
                leftmost_point = (x, y)
            if rightmost_point is None or (x + w) > rightmost_point[0]:
                rightmost_point = (x + w, y + h)

        return ret, leftmost_point, rightmost_point
    
    # 공 인식
    def cvCircleDetect(self, img):
        img = cv2.cvtColor(img, cv2.COLOR_BGR2HLS)
        lower_red = np.array([124, 26, 176])
        upper_red = np.array([179, 180, 255])
        mask = cv2.inRange(img, lower_red, upper_red)
        kernel = np.ones((4, 4), np.uint8)
        mask = cv2.erode(mask, kernel)
        mask = cv2.dilate(mask, kernel)
        contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        for contour in contours:
            if cv2.contourArea(contour) > 100:
                (x, y), radius = cv2.minEnclosingCircle(contour)
                return True, [int(x-radius), int(y-radius), int(x+radius), int(y+radius)]
        return False, [False, False, False, False]
    
    def longChecker_R(self, img):
        for y in range(100,480):
            img[y, :, :] = 0
            
        ret, point = self.is_hole(img)
        if ret == True:
            x, y = point[0], point[1]
        else:
            ret, x, y = self.holeDetect(img)
            
        if ret == False:
            return "R-turn", img, None
        
        cv2.line(img, (230,0), (120,480), (0,0,255), 1)
        # cv2.line(img, (315,0), (185,480), (255,0,0), 1)
        cv2.line(img, (150,0), (45,480), (255,0,0), 1)

        # 5 degree
        cv2.line(img, (310,0), (120,480), (200,200,0), 1)
        cv2.line(img, (110,0), (120,480), (200,200,0), 1)

        # 10 degree
        cv2.line(img, (360,0), (120,480), (0,200,200), 1)
        cv2.line(img, (0,0), (120,480), (0,200,200), 1)

        # 20 degree
        cv2.line(img, (460,0), (120,480), (200,0,200), 1)
        
        cv2.circle(img, (x,y), 3, (0,255,0), 3)
        
        if ret == True and ( ((4800-32*x)/7) < y < ((11040-48*x)/11) ):
            return "!!!R-Shot!!!", img, 20
        elif ret == True and y <= (4800-32*x)/7:
            if y < (-5280+48*x):  
                return "R-turn-5", img, None
            elif y < (-4*x):
                return "R-turn-10", img, None
            else:
                return "R-turn-20", img, None
        elif ret == True and y >= (11040-48*x)/11:
            if y < (14880-48*x)/19:
                return "L-turn-5", img, None
            elif y < (720-2*x):
                return "L-turn-10", img, None
            elif y < (11040-24*x)/17:
                return "L-turn-20", img, None
            else:
                return "L-turn", img, None
        else:
            return "R-turn", img, None
    
    def longChecker_R_accurate(self, img):
        # ROI
        for y in range(100,480):
            img[y, :, :] = 0
            
        ret, point = self.is_hole(img)
        if ret == True:
            x, y = point[0], point[1]
        else:
            ret, x, y = self.holeDetect_close(img)
            
        if ret == False:
            return "R-turn", img, None
        
        cv2.line(img, (324,0), (120,480), (0,0,255), 1)
        cv2.line(img, (330,0), (150,480), (255,0,0), 1)
        cv2.line(img, (318,0), (90,480), (255,0,0), 1)
        # 5 degree
        cv2.line(img, (390,0), (120,480), (200,200,0), 1)
        # cv2.line(img, (260,0), (120,480), (200,200,0), 1)
        # 10 degree
        cv2.line(img, (460,0), (120,480), (0,200,200), 1)
        cv2.line(img, (240,0), (120,480), (0,200,200), 1)
        # 20 degree
        cv2.line(img, (520,0), (120,480), (200,0,200), 1)
        cv2.line(img, (180,0), (120,480), (200,0,200), 1)
        
        cv2.circle(img, (x,y), 3, (0,255,0), 3)
        
        if ret == True and ( (12720-40*x)/19 < y < (2640-8*x)/3):
            return "!!!R-Shot!!!", img, 20
        elif ret == True and y <= (12720-40*x)/19:
            if y > (960-4*x):  
                return "R-turn-5", img, None
            elif y > (1440-8*x):
                return "R-turn-10", img, None
            # elif y > (1440-8*x):
            #     return "R-turn-20", img, None
            else:
                return "R-turn-20", img, None
        elif ret == True and y >= (2640-8*x)/3:
            if y < (6240-16*x)/9:
                return "L-turn-5", img, None
            elif y < (11040-24*x)/17:
                return "L-turn-10", img, None
            elif y < (3120-6*x)/5:
                return "L-turn-20", img, None
            else:
                return "L-turn", img, None
        else:
            return "R-turn", img, None
        
    def longChecker_par3_first_shot(self, img):
        for y in range(70,480):
            img[y, :, :] = 0

        ret, point = self.is_hole(img)
        if ret == True:
            x, y = point[0], point[1]
        else:
            ret, x, y = self.holeDetect(img)
            
        if ret == False:
            return "L-turn", img, None
        
        cv2.line(img, (325,0), (522,480), (0,0,255), 1)
        cv2.line(img, (340,0), (580,480), (255,0,0), 1)
        cv2.line(img, (310,0), (470,480), (255,0,0), 1)
        
        # 5 degree
        #cv2.line(img, (360,0), (522,480), (200,200,0), 1)
        #cv2.line(img, (295,0), (522,480), (200,200,0), 1)
        
        # 10 degree
        cv2.line(img, (430,0), (522,480), (0,200,200), 1)
        cv2.line(img, (253,0), (522,480), (0,200,200), 1)
        
        # 20 degree
        cv2.line(img, (500,0), (522,480), (200,0,200), 1)
        cv2.line(img, (150,0), (522,480), (200,0,200), 1)
        
        cv2.circle(img, (x,y), 3, (0,255,0), 3)
        if ret == True and ( (-930+3*x) > y > (-680+2*x)):
            dist = ball_distance(70, y)
            if dist > 130:
                power = 22
            elif dist > 110:
                power = 20
            elif dist > 80:
                power = 20
            elif dist > 75:
                power = 19
            elif dist > 70:
                power = 18
            elif dist > 60:
                power = 17
            elif dist > 50:
                power = 16
            elif dist > 45:
                power = 15
            elif dist > 30:
                power = 13
            else:
                power = 13
            return "!!!Shot!!!", img, power
        elif ret == True and y <= (-680+2*x):
            if y < (-120000+240*x)/11:  
                return "L-turn-20", img, None
            elif y < (-51600+120*x)/23:
                return "L-turn-10", img, None
            # elif y < (-28800+80*x)/27:
            #     return "L-turn-10", img, None
            else:
                return "L-turn-5", img, None
        elif ret == True and y >= (-930+3*x):
            if y > (-6000+40*x)/31:
                return "R-turn-20", img, None
            elif y > (-121440+480*x)/269:
                return "R-turn-10", img, None
            # elif y > (-141600+480*x)/227:
            #     return "R-turn-10", img, None
            else:
                return "R-turn-5", img, None
        else:
            return "L-turn", img, None
        
    def longChecker(self, img):
        ret, point = self.is_hole(img)
        if ret == True:
            x, y = point[0], point[1]
        else:
            ret, x, y = self.holeDetect(img)
            
        if ret == False:
            return "L-turn", img, None
        
        cv2.line(img, (344,0), (520,480), (0,0,255), 1)
        cv2.line(img, (350,0), (560,480), (255,0,0), 1)
        cv2.line(img, (338,0), (480,480), (255,0,0), 1)
        
        # 5 degree
        cv2.line(img, (374,0), (520,480), (200,200,0), 1)
        #cv2.line(img, (295,0), (522,480), (200,200,0), 1)
        
        # 10 degree
        cv2.line(img, (430,0), (520,480), (0,200,200), 1)
        cv2.line(img, (250,0), (520,480), (0,200,200), 1)
        
        # 20 degree
        cv2.line(img, (510,0), (520,480), (200,0,200), 1)
        cv2.line(img, (140,0), (520,480), (200,0,200), 1)
        
        cv2.circle(img, (x,y), 3, (0,255,0), 3)
        if ret == True and ( (-81120+240*x)/71 > y > (-5600+16*x)/7):
            dist = ball_distance(70, y)
            if dist > 130:
                power = 20
            elif dist > 110:
                power = 20
            elif dist > 80:
                power = 20
            elif dist > 75:
                power = 20
            elif dist > 70:
                power = 19
            elif dist > 60:
                power = 18
            elif dist > 50:
                power = 17
            elif dist > 45:
                power = 16
            elif dist > 30:
                power = 15
            else:
                power = 15
            return "!!!Shot!!!", img, power
        elif ret == True and y <= (-5600+16*x)/7:
            if y < (-24480+48*x):  
                return "L-turn", img, None
            elif y < (-6880+16*x)/3:
                return "L-turn-20", img, None
            elif y < (-89760+240*x)/73:
                return "L-turn-10", img, None
            else:
                return "L-turn-5", img, None
        elif ret == True and y >= (-81120+240*x)/71:
            if y > (-3360+24*x)/19:
                return "R-turn-20", img, None
            elif y > (-4000+16*x)/9:
                return "R-turn-10", img, None
            # elif y > (-141600+480*x)/227:
            #     return "R-turn-10", img, None
            else:
                return "R-turn-5", img, None
        else:
            return "L-turn", img, None
    
    def longChecker_preserve(self, img):
        ret, point = self.is_hole(img)
        if ret == True:
            x, y = point[0], point[1]
        else:
            ret, x, y = self.holeDetect(img)
            
        if ret == False:
            return "L-turn", img, None
        
        cv2.line(img, (325,0), (522,480), (0,0,255), 1)
        cv2.line(img, (333,0), (580,480), (255,0,0), 1)
        cv2.line(img, (318,0), (470,480), (255,0,0), 1)
        
        # 5 degree
        #cv2.line(img, (360,0), (522,480), (200,200,0), 1)
        #cv2.line(img, (295,0), (522,480), (200,200,0), 1)
        
        # 10 degree
        cv2.line(img, (430,0), (522,480), (0,200,200), 1)
        cv2.line(img, (253,0), (522,480), (0,200,200), 1)
        
        # 20 degree
        cv2.line(img, (500,0), (522,480), (200,0,200), 1)
        cv2.line(img, (150,0), (522,480), (200,0,200), 1)
        
        cv2.circle(img, (x,y), 3, (0,255,0), 3)
        if ret == True and ( (-19080+60*x)/19 > y > (-159840+480*x)/247):
            dist = ball_distance(70, y)
            if dist > 130:
                power = 22
            elif dist > 110:
                power = 20
            elif dist > 80:
                power = 20
            elif dist > 75:
                power = 19
            elif dist > 70:
                power = 18
            elif dist > 60:
                power = 17
            elif dist > 50:
                power = 16
            elif dist > 45:
                power = 15
            elif dist > 30:
                power = 13
            else:
                power = 13
            return "!!!Shot!!!", img, power
        elif ret == True and y <= (-159840+480*x)/247:
            if y < (-120000+240*x)/11:  
                return "L-turn-20", img, None
            elif y < (-51600+120*x)/23:
                return "L-turn-10", img, None
            # elif y < (-28800+80*x)/27:
            #     return "L-turn-10", img, None
            else:
                return "L-turn-5", img, None
        elif ret == True and y >= (-19080+60*x)/19:
            if y > (-6000+40*x)/31:
                return "R-turn-20", img, None
            elif y > (-121440+480*x)/269:
                return "R-turn-10", img, None
            # elif y > (-141600+480*x)/227:
            #     return "R-turn-10", img, None
            else:
                return "R-turn-5", img, None
        else:
            return "L-turn", img, None
    
    def longChecker_far(self, img):
        ret, point = self.is_hole(img)
        if ret == True:
            x, y = point[0], point[1]
        else:
            ret, x, y = self.holeDetect_far(img)
            
        if ret == False:
            return "L-turn", img, None
        
        cv2.line(img, (325,0), (522,480), (0,0,255), 1)
        cv2.line(img, (333,0), (580,480), (255,0,0), 1)
        cv2.line(img, (318,0), (470,480), (255,0,0), 1)
        
        # 5 degree
        #cv2.line(img, (360,0), (522,480), (200,200,0), 1)
        #cv2.line(img, (295,0), (522,480), (200,200,0), 1)
        
        # 10 degree
        cv2.line(img, (430,0), (522,480), (0,200,200), 1)
        cv2.line(img, (253,0), (522,480), (0,200,200), 1)
        
        # 20 degree
        cv2.line(img, (500,0), (522,480), (200,0,200), 1)
        cv2.line(img, (150,0), (522,480), (200,0,200), 1)
        
        cv2.circle(img, (x,y), 3, (0,255,0), 3)
        if ret == True and ( (-19080+60*x)/19 > y > (-159840+480*x)/247):
            dist = ball_distance(70, y)
            if dist > 130:
                power = 22
            elif dist > 110:
                power = 20
            elif dist > 80:
                power = 20
            elif dist > 75:
                power = 19
            elif dist > 70:
                power = 18
            elif dist > 60:
                power = 17
            elif dist > 50:
                power = 16
            elif dist > 45:
                power = 15
            elif dist > 30:
                power = 13
            else:
                power = 13
            return "!!!Shot!!!", img, power
        elif ret == True and y <= (-159840+480*x)/247:
            if y < (-120000+240*x)/11:  
                return "L-turn-20", img, None
            elif y < (-51600+120*x)/23:
                return "L-turn-10", img, None
            # elif y < (-28800+80*x)/27:
            #     return "L-turn-10", img, None
            else:
                return "L-turn-5", img, None
        elif ret == True and y >= (-19080+60*x)/19:
            if y > (-6000+40*x)/31:
                return "R-turn-20", img, None
            elif y > (-121440+480*x)/269:
                return "R-turn-10", img, None
            # elif y > (-141600+480*x)/227:
            #     return "R-turn-10", img, None
            else:
                return "R-turn-5", img, None
        else:
            return "L-turn", img, None
    
    def longChecker_close(self, img):
        ret, point = self.is_hole(img)
        if ret == True:
            x, y = point[0], point[1]
        else:
            ret, x, y = self.holeDetect_close(img)
            
        if ret == False:
            return "L-turn", img, None
        
        cv2.line(img, (325,0), (522,480), (0,0,255), 1)
        cv2.line(img, (333,0), (580,480), (255,0,0), 1)
        cv2.line(img, (318,0), (470,480), (255,0,0), 1)
        
        # 5 degree
        #cv2.line(img, (360,0), (522,480), (200,200,0), 1)
        #cv2.line(img, (295,0), (522,480), (200,200,0), 1)
        
        # 10 degree
        cv2.line(img, (430,0), (522,480), (0,200,200), 1)
        cv2.line(img, (253,0), (522,480), (0,200,200), 1)
        
        # 20 degree
        cv2.line(img, (500,0), (522,480), (200,0,200), 1)
        cv2.line(img, (150,0), (522,480), (200,0,200), 1)
        
        cv2.circle(img, (x,y), 3, (0,255,0), 3)
        if ret == True and ( (-19080+60*x)/19 > y > (-159840+480*x)/247):
            dist = ball_distance(70, y)
            if dist > 130:
                power = 22
            elif dist > 110:
                power = 20
            elif dist > 80:
                power = 20
            elif dist > 75:
                power = 19
            elif dist > 70:
                power = 18
            elif dist > 60:
                power = 17
            elif dist > 50:
                power = 16
            elif dist > 45:
                power = 15
            elif dist > 30:
                power = 13
            else:
                power = 13
            return "!!!Shot!!!", img, power
        elif ret == True and y <= (-159840+480*x)/247:
            if y < (-120000+240*x)/11:  
                return "L-turn-20", img, None
            elif y < (-51600+120*x)/23:
                return "L-turn-10", img, None
            # elif y < (-28800+80*x)/27:
            #     return "L-turn-10", img, None
            else:
                return "L-turn-5", img, None
        elif ret == True and y >= (-19080+60*x)/19:
            if y > (-6000+40*x)/31:
                return "R-turn-20", img, None
            elif y > (-121440+480*x)/269:
                return "R-turn-10", img, None
            # elif y > (-141600+480*x)/227:
            #     return "R-turn-10", img, None
            else:
                return "R-turn-5", img, None
        else:
            return "L-turn", img, None
        
    def longChecker_gamble_firstshot(self, img):
        ret, point = self.is_hole(img)
        if ret == True:
            x, y = point[0], point[1]
        else:
            ret, x, y = self.holeDetect_close(img)
            
        if ret == False:
            return "L-turn", img, None
        
        # cv2.line(img, (315,0), (522,480), (0,0,255), 1)
        cv2.line(img, (340,0), (522,480), (255,0,0), 1)
        cv2.line(img, (245,0), (465,480), (255,0,0), 1)

        # 5 degree
        #cv2.line(img, (360,0), (522,480), (200,200,0), 1)
        cv2.line(img, (200,0), (522,480), (200,200,0), 1)

        # 10 degree
        cv2.line(img, (430,0), (522,480), (0,200,200), 1)
        cv2.line(img, (90,0), (522,480), (0,200,200), 1)

        # 20 degree
        cv2.line(img, (570,0), (522,480), (200,0,200), 1)
        # cv2.line(img, (0,0), (522,480), (200,0,200), 1)
        
        cv2.circle(img, (x,y), 3, (0,255,0), 3)
        if ret == True and ( (-5880+24*x)/11 > y > (-81600+240*x)/91):
            dist = ball_distance(70, y)
            if dist > 130:
                power = 22
            elif dist > 110:
                power = 20
            elif dist > 80:
                power = 20
            elif dist > 75:
                power = 19
            elif dist > 70:
                power = 18
            elif dist > 60:
                power = 17
            elif dist > 50:
                power = 16
            elif dist > 45:
                power = 15
            elif dist > 30:
                power = 13
            else:
                power = 13
            return "!!!Shot!!!", img, power
        elif ret == True and y <= (-81600+240*x)/91:
            if y > (5700-10*x):  
                return "L-turn", img, None
            else:
                if y > (-51600+120*x)/23:
                    return "L-turn-5", img, None
                else:
                    return "L-turn-10", img, None
        elif ret == True and y >= (-5880+24*x)/11:
            if y < (-48000+240*x)/161:
                return "R-turn-5", img, None
            # elif y > (-121440+480*x)/269:
            #     return "R-turn-10", img, None
            # elif y > (-141600+480*x)/227:
            #     return "R-turn-10", img, None
            elif y < (-900+10*x)/9:
                return "R-turn-10", img, None
            else:
                return "R-turn-20", img, None
        else:
            return "L-turn", img, None
    
    def longChecker_gamble_firstshot_plus(self, img):
        ret, point = self.is_hole(img)
        if ret == True:
            x, y = point[0], point[1]
        else:
            ret, x, y = self.holeDetect_close(img)
            
        if ret == False:
            return "L-turn", img, None
        
        cv2.line(img, (300,0), (510,480), (0,0,255), 1)
        cv2.line(img, (340,0), (580,480), (255,0,0), 1)
        cv2.line(img, (245,0), (465,480), (255,0,0), 1)
        
        # 5 degree
        #cv2.line(img, (360,0), (522,480), (200,200,0), 1)
        #cv2.line(img, (295,0), (522,480), (200,200,0), 1)
        
        # 10 degree
        cv2.line(img, (430,0), (522,480), (0,200,200), 1)
        # cv2.line(img, (253,0), (522,480), (0,200,200), 1)
        
        # 20 degree
        cv2.line(img, (500,0), (522,480), (200,0,200), 1)
        cv2.line(img, (150,0), (522,480), (200,0,200), 1)
        
        cv2.circle(img, (x,y), 3, (0,255,0), 3)
        if ret == True and ( (-5880+24*x)/11 > y > (-4800+16*x)/7):
            dist = ball_distance(70, y)
            if dist > 130:
                power = 22
            elif dist > 110:
                power = 20
            elif dist > 80:
                power = 20
            elif dist > 75:
                power = 19
            elif dist > 70:
                power = 18
            elif dist > 60:
                power = 17
            elif dist > 50:
                power = 16
            elif dist > 45:
                power = 15
            elif dist > 30:
                power = 13
            else:
                power = 13
            return "!!!Shot!!!", img, power
        elif ret == True and y <= (-4800+16*x)/7:
            if y < (-120000+240*x)/11:  
                return "L-turn", img, None
            elif y < (-51600+120*x)/23:
                return "L-turn-20", img, None
            elif y < (-81600+240*x)/91:
                return "L-turn-10", img, None
            else:
                return "L-turn-10", img, None
        elif ret == True and y >= (-5880+24*x)/11:
            if y > (-6000+40*x)/31:
                return "R-turn-20", img, None
            # elif y > (-121440+480*x)/269:
            #     return "R-turn-10", img, None
            # elif y > (-141600+480*x)/227:
            #     return "R-turn-10", img, None
            else:
                return "R-turn-10", img, None
        else:
            return "L-turn", img, None
    
    def shortChecker(self, img):
        ret, (x, y) = self.is_hole(img)
        if ret == False:
            ret, [x, y] = self.is_arrow(img)
            if ret == True:
                return "NoHole", img
            else:
                ret, (x, y) = self.holeDetect_center(img)
                if ret == False:
                    return "NoHole", img

        # shot y boundary
        cv2.line(img, (0, 250), (640, 250), (255,0,0), 2)
        cv2.line(img, (0, 320), (640, 320), (0,255,0), 2)
        cv2.line(img, (0, 400), (640, 400), (255,0,0), 2)
        
        cv2.line(img, (255, 0), (255, 480), (255,0,0), 2)
        cv2.line(img, (333, 0), (333, 480), (0,255,0), 2)
        cv2.line(img, (420, 0), (420, 480), (255,0,0), 2)
        # x center
        
        cv2.circle(img, (x,y), 3, (0,0,255), 3)
        if ret == True and 250<y<400 and x<252:
            return "!!!Shot!!!", img
        elif ret == True and 250<y<400 and x>423:
            return "!!!R-Shot!!!", img
        elif ret == True  and 242<=y<=408 and 252<=x<=423:
            return "!!!Goal!!!", img
        elif ret == True and y <= 250 and x<333:
            return "L-turn", img
        elif ret == True and y <= 250 and x>=333:
            return "R-turn-20", img
        elif ret == True and 400 <= y and x<333:
            return "R-turn-20", img
        elif ret == True and 400 <= y and x>=333:
            return "L-turn", img
        else:
            return "NoHole", img
        
    def shortChecker_R(self, img):
        ret, x, y = self.holeDetect(img)
        if ret == False:
            return "NoHole", img

        # shot y boundary
        cv2.line(img, (280, 0), (280, 480), (255,0,0), 2)
        cv2.line(img, (560, 0), (560, 480), (255,0,0), 2)
        
        cv2.circle(img, (x,y), 3, (0,0,255), 3)
        if x<280:
            return "LLL-turn", img
        elif x<560:
            return "LLL-turn", img
        else:
            return "LLLL-turn", img
    
if __name__ == "__main__":
    camera = Camera()
    while True:
        frame = camera.get_image()

        #ret, rect = camera.is_bunker(frame.copy())
        #if ret:
        #    cv2.rectangle(frame, (rect[0], rect[1]), (rect[0]+rect[2], rect[1]+rect[3]), (0,255,255), 2)
        #cv2.imshow("Frame", frame)
        #if cv2.waitKey(16) == ord("q"):
        #    break
        ret, ball_box = camera.cvCircleDetect(frame.copy())
        if ret:
            cv2.rectangle(frame, (ball_box[0], ball_box[1]), (ball_box[2], ball_box[3]), (0,0,255), 2)
        cv2.imshow("detect", frame)
        if cv2.waitKey(16) == ord("q"):
            break
        
        
    cv2.destroyAllWindows()
