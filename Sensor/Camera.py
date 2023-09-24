import cv2
import numpy as np
import time
import math
from imutils.video import WebcamVideoStream
from imutils.video import FPS
from ultralytics import YOLO

class Camera:
    def __init__(self):
        # 카메라 설정
        self.cam = WebcamVideoStream(-1).start()
        self.fps = FPS()
        shape = (self.height, self.width, _) = self.get_image().shape
        print(shape) # 세로, 가로 출력
        time.sleep(2)

        # YOLO 설정
        self.model = YOLO('yolov8n.pt')
    
    # 이미지 공급 쓰레드에서 이미지 하나 get.    
    def get_image(self):
        try:
            print("image get")
            return self.cam.read().copy()
        except AttributeError: # 이미지를 얻지 못할경우 검은화면 반환
            print("Attribute Error")
            return np.zeros(shape=(480, 640, 3), dtype="uint8")
    
    # 홀 인식
    def is_hole(self, img):
        # 이미지를 HLS 색공간으로 변환
        img_hls = cv2.cvtColor(img, cv2.COLOR_BGR2HLS)
        
        # 색상, 밝기, 채도 범위 설정
        lower_bound = np.array([0, 0, 0])
        upper_bound = np.array([60, 255, 255])
        
        # 범위 내의 픽셀을 마스크로 만들기
        mask = cv2.inRange(img_hls, lower_bound, upper_bound)

        contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        
        # 검은색이 아닌 영역을 사각형으로 표시
        for contour in contours:
            x, y, w, h = cv2.boundingRect(contour)
            if w < 10 or h < 10 or h / w < 1.5:
                continue
            return True, [x, y, w, h]
        return False, None
    
    # 카메라와 공, 카메라와 홀 사이의 거리를 알 때 공과 홀 사이의 거리 계산
    def ball_hole(self, ball, hole, neck_angle):
        # neck angle은 60 or 80
        neck_angle = math.radians(neck_angle)
        ball_hole = math.sqrt(ball**2 + hole**2 - 2*ball*hole*math.cos(neck_angle))
        return ball_hole
    
    def cvCircleDetect(self, img):
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        
        circles = cv2.HoughCircles(gray, cv2.HOUGH_GRADIENT, 1, 100, param1=100, param2=40, minRadius=40, maxRadius=100)
        
        if np.any(circles == None):
            return False, img, None
        
        for i in circles[0]:
            cv2.circle(img, (i[0], i[1]), i[2], (255,255,255), 3)
        return True, img, (circles[0][0][0],circles[0][0][1])
    
    def yoloDetect(self, img):
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        result = self.model.predict(img, conf = 0.8)[0]
        return result

if __name__ == "__main__":
    Camera = Camera()