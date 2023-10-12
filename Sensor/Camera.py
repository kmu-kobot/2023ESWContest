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
        mask2 = Image.fromarray(mask)
        bbox = mask2.getbbox()
        if bbox != None:
            x1, y1, x2, y2 = bbox
            img = cv2.rectangle(img, (x1,y1), (x2,y2), (0,255,0), 4)
        return mask
    
    # 홀 인식
    def is_hole(self, img):
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
        lower_red = np.array([119, 28, 73])
        upper_red = np.array([179, 255, 255])
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
        ret, ball_box = camera.cvCircleDetect(frame.copy())
        if ret:
            cv2.rectangle(frame, (ball_box[0], ball_box[1]), (ball_box[2], ball_box[3]), (0,0,255), 2)
        cv2.imshow("detect", frame)
        if cv2.waitKey(16) == ord("q"):
            break
        
        
    cv2.destroyAllWindows()
