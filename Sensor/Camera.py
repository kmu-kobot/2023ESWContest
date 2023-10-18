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
        
    def nothing(self,x):
        pass
    
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
        return False, None, None
    
    def yellow_detection_params(self):
        # 초기 노란색 검출 트랙바 설정
        cv2.namedWindow("Yellow_Detection", cv2.WINDOW_NORMAL)
        cv2.createTrackbar('low_H', 'Yellow_Detection', 13, 179, self.nothing)
        cv2.createTrackbar('high_H', 'Yellow_Detection', 37, 179, self.nothing)
        cv2.createTrackbar('low_S', 'Yellow_Detection', 0, 255, self.nothing)
        cv2.createTrackbar('high_S', 'Yellow_Detection', 255, 255, self.nothing)
        cv2.createTrackbar('low_V', 'Yellow_Detection', 167, 255, self.nothing)
        cv2.createTrackbar('high_V', 'Yellow_Detection', 255, 255, self.nothing)

    def get_yellow_detection_values(self):
        # 노란색 검출 트랙바에서 HSV 범위 가져오기
        low_H = cv2.getTrackbarPos('low_H', 'Yellow_Detection')
        high_H = cv2.getTrackbarPos('high_H', 'Yellow_Detection')
        low_L = cv2.getTrackbarPos('low_S', 'Yellow_Detection')
        high_L = cv2.getTrackbarPos('high_S', 'Yellow_Detection')
        low_S = cv2.getTrackbarPos('low_V', 'Yellow_Detection')
        high_S = cv2.getTrackbarPos('high_V', 'Yellow_Detection')

        return low_H, high_H, low_L, high_L, low_S, high_S

    # 홀 인식
    def is_hole(self, img):
        #노란색 검출 트랙바
        self.yellow_detection_params()

        low_H, high_H, low_L, high_L, low_S, high_S = self.get_yellow_detection_values()
        img2 = img.copy()
        
        #이미지를 HSV 색 공간으로 변환
        hsv = cv2.cvtColor(img2, cv2.COLOR_BGR2HSV)

        lower_yellow = np.array([low_H, low_L, low_S])
        upper_yellow = np.array([high_H, high_L, high_S])

        #노란색 추출 마스크
        mask = cv2.inRange(hsv, lower_yellow, upper_yellow)

        detector = cv2.SimpleBlobDetector_create()
        params = cv2.SimpleBlobDetector_Params()

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
        params.minDistBetweenBlobs = 100

        # 파라미터
        detector = cv2.SimpleBlobDetector_create(params)

        keypoints = detector.detect(mask)
        detected_points = []
        for k in keypoints:
            cv2.circle(img2, (int(k.pt[0]), int(k.pt[1])), int(k.size / 2), (0, 0, 255), -1)
            cv2.line(img2, (int(k.pt[0]) - 20, int(k.pt[1])), (int(k.pt[0]) + 20, int(k.pt[1])), (0, 0, 0), 3)
            cv2.line(img2, (int(k.pt[0]), int(k.pt[1]) - 20), (int(k.pt[0]), int(k.pt[1]) + 20), (0, 0, 0), 3)
            detected_points.append((int(k.pt[0])-int(k.size/2),int(k.pt[1])+int(k.size/2),int(k.pt[0])+int(k.size/2),int(k.pt[1])-int(k.size/2)))

        opacity = 0.5
        cv2.addWeighted(img2, opacity, img, 1 - opacity, 0, img)

        if detected_points:  # Check if any keypoints were detected
            return True, detected_points

        return False, [False,False,False,False]
        '''
            return True, [int(k.pt[0])-int(k.size/2),int(k.pt[1])+int(k.size/2),int(k.pt[0])+int(k.size/2),int(k.pt[1])-int(k.size/2)] # detect
        return False, [False,False,False,False]
        '''

        '''
        img = cv2.cvtColor(img, cv2.COLOR_BGR2HLS)
        # 색상, 밝기, 채도 범위 설정
        lower_bound = np.array([0, 0, 0])
        upper_bound = np.array([60, 255, 255])
        
        # 범위 내의 픽셀을 마스크로 만들기
        mask = cv2.inRange(img, lower_bound, upper_bound)

        contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        
        # 검은색이 아닌 영역을 사각형으로 표시
        for contour in contours:
            x, y, w, h = cv2.boundingRect(contour)
            if w < 10 or h < 10 or h / w < 1.5:
                continue
            return True, [x, y, w, h]
        return False, None
        '''
    
    def preprocess(self,img):
        self.yellow_detection_params()
        low_H, high_H, low_L, high_L, low_S, high_S = self.get_yellow_detection_values()
        lower_yellow = np.array([low_H, low_L, low_S])
        upper_yellow = np.array([high_H, high_L, high_S])

        img_hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
        yellow_mask = cv2.inRange(img_hsv,lower_yellow,upper_yellow)

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
                    cv2.drawContours(img, [cnt], -1, (0, 255, 0), 3)
                    cv2.circle(img, arrow_tip, 3, (0, 0, 255), cv2.FILLED)
                    return True, arrow_tip
        return False, [False,False]
        '''
            # 최솟값과 최댓값을 업데이트
            for point in cnt:
                point = tuple(point[0])
                if point[0] < leftmost[0]:
                    leftmost = point
                if point[0] > rightmost[0]:
                    rightmost = point
                if point[1] < topmost[1]:
                    topmost = point
                if point[1] > bottommost[1]:
                    bottommost = point

        if leftmost[0] != float('inf'):  # 화살표 유사한 윤곽선이 발견된 경우
            return True, [leftmost[0], topmost[1], rightmost[0], bottommost[1]]
        return False, None
        '''


    # 벙커 인식
    def is_bunker(self, img):
        lower_bound = np.array([0, 135, 0])
        upper_bound = np.array([180, 255, 31])

        mask = cv2.inRange(img, lower_bound, upper_bound)

        contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

        for contour in contours:
            x, y, w, h = cv2.boundingRect(contour)
            if w < 50 or h < 50:
                continue
            return True, [x, y, w, h]
        return False, None
        
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
        ret, hole_box = camera.is_hole(frame.copy())
        arrow_box = camera.is_arrow(frame.copy())
        
        ret, ball_box = camera.cvCircleDetect(frame.copy())
        
        if ret:
            cv2.rectangle(frame, (ball_box[0], ball_box[1]), (ball_box[2], ball_box[3]), (0,0,255), 2)
        cv2.imshow("detect", frame)

        if cv2.waitKey(16) == ord("q"):
            break
        
        
    cv2.destroyAllWindows()
