import cv2
import numpy as np
import time
import math
from PIL import Image
from imutils.video import WebcamVideoStream
from imutils.video import FPS

class Camera:
    def __init__(self):
        # 카메라 설정
        self.lowerLimitP = np.array([152, 55, 194], dtype=np.uint8)
        self.upperLimitP = np.array([169,205,255], dtype=np.uint8)
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
        mask = cv2.inRange(hsvImg, self.lowerLimitP, self.upperLimitP)
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
        if max_area < 100:
                max_area_idx = -1
        if max_area_idx != -1:
            x1, y1, w, h, _ = stats[max_area_idx]
            x2, y2 = x1 + w, y1 + h
            # img = cv2.rectangle(img, (x1, y1), (x2, y2), (0, 255, 0), 4)
            return True, (x1, y1), (x2, y2)
        return False, (False, False), (False, False)
    
    # 홀 인식
    def is_hole(self, img):
        img2 = img.copy()
        
        #이미지를 HSV 색 공간으로 변환
        hsv = cv2.cvtColor(img2, cv2.COLOR_BGR2HSV)
        
        #노란색 추출 마스크
        lower_yellow = np.array([0, 48, 221])
        upper_yellow = np.array([40, 255, 255])
        mask = cv2.inRange(hsv, lower_yellow, upper_yellow)

        detector = cv2.SimpleBlobDetector_create() # 개체 검출 객체 생성
        params = cv2.SimpleBlobDetector_Params()   # 파라미터 설정 객체(크기, 원형도, 관성 비율)

        # Area
        params.filterByArea = True
        params.minArea = 250  # 최소 홀 크기
        params.maxArea = 500000000  # 최대 홀 크기

        # Circularity
        params.filterByCircularity = True
        params.minCircularity = 0.2  # 최소 원형도

        # Convexity
        params.filterByConvexity = True
        params.minConvexity = 0.1

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
        lower_bound = np.array([0, 48, 221])
        upper_bound = np.array([40, 255, 255])
        hsvImg = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
        mask = cv2.inRange(hsvImg, lower_bound, upper_bound)
        # cv2.imshow("Frame", mask)
        # cv2.waitKey(1)
        num_labels, labels, stats, centroids = cv2.connectedComponentsWithStats(mask, connectivity=8)
        max_area = -1
        max_density = -1
        max_area_idx = -1
        # 노이즈를 잡기 위한 최소한의 밀집도
        min_density = 0.2  # 예시: 50% 이상의 픽셀이 1이어야 함

        for i in range(1, num_labels):  # 0번은 배경이므로 무시합니다.
            area = stats[i,cv2.CC_STAT_AREA]
            density = stats[i, cv2.CC_STAT_AREA] / (stats[i, cv2.CC_STAT_WIDTH] * stats[i, cv2.CC_STAT_HEIGHT])

            if density > min_density and area > max_area:
                max_area = area
                max_area_idx = i
        if max_area < 100:
                max_area_idx = -1
        if max_area_idx != -1:
            x1, y1, w, h, _ = stats[max_area_idx]
            x2, y2 = x1 + w, y1 + h
            # img = cv2.rectangle(img, (x1, y1), (x2, y2), (0, 255, 0), 4)
            return True, (x1, y1, x2, y2)
        return False, (False, False, False, False)
        
    def preprocess(self,img):
        lower_yellow = np.array([0, 48, 221])
        upper_yellow = np.array([40, 255, 255])
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
        
    # 카메라와 공, 카메라와 홀 사이의 거리를 알 때 공과 홀 사이의 거리 계산
    def ball_hole(self, ball, hole, neck_angle):
        # neck angle은 60 or 80
        neck_angle = math.radians(neck_angle)
        ball_hole = math.sqrt(ball**2 + hole**2 - 2*ball*hole*math.cos(neck_angle))
        return ball_hole
    
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
    
    def longChecker(self, img):
        ret, xyxy = self.holeDetect(img)
        if ret == False:
            return False, img
        x1, y1, x2, y2 = xyxy
        x = int((x1 + x2)/2)
        y = int((y1 + y2)/2)
        cv2.line(img, (310,0), (550,480), (0,0,255), 2)
        cv2.line(img, (335,0), (640,380), (0,0,255), 2)
        cv2.circle(img, (x,y), 3, (0,255,0), 3)
        if ret == True and (2*x - 620 > y > (76*x-25460)/61):
            return "!!!Shot!!!", img
        elif ret == True and y > 2*x - 620:
            return "R-turn", img
        else:
            return "L-turn", img
    
    def shortChecker(self, img):
        ret, (x, y) = self.is_hole(img)
        if ret == False:
            return False, img
        # shot y boundary
        cv2.line(img, (0,210), (640, 210), (255,0,0), 2)
        cv2.line(img, (0,260), (640, 260), (0,255,0), 2)
        cv2.line(img, (0,300), (640, 300), (255,0,0), 2)
        # x center
        cv2.line(img, (320,0), (320, 480), (0,0,255), 2)
        
        cv2.circle(img, (x,y), 3, (0,255,0), 3)
        if ret == True and 220<y<330 and x<250:
            return "!!!Shot!!!", img
        elif ret == True and 220<y<330 and x>=390:
            return "!!!R-Shot!!!", img
        elif ret == True  and 220<=y<=330 and 250<=x<=390:
            return "!!!Goal!!!", img
        elif ret == True and y <= 220 and x<320:
            return "L-turn", img
        elif ret == True and y <= 220 and x>=320:
            return "R-turn", img
        elif ret == True and 330 <= y and x<320:
            return "R-turn", img
        elif ret == True and 330 <= y and x>=320:
            return "L-turn", img
        else:
            return "NoHole", img
    
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
