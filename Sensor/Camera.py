import cv2
import numpy as np
import time
from imutils.video import WebcamVideoStream
from imutils.video import FPS


class Camera:
    def __init__(self):
        self.cam = WebcamVideoStream(-1).start
        self.fps = FPS()
        shape = (self.height, self.width, _) = self.get_image().shape
        print(shape) # 세로, 가로 출력
        time.sleep(2)
        
        while cv2.waitKey():
            img = self.get_image
            cv2.imshow("camera", img)
        cv2.destroyAllWindows
    
    # 이미지 공급 쓰레드에서 이미지 하나 get.    
    def get_image(self):
        try:
            return np.array(self.cam.read().copy())
        except AttributeError: # 이미지를 얻지 못할경우 검은화면 반환
            return np.zeros(shape=(480, 640, 3), dtype="uint8")
        
    def ball_position(self, img):
        return 0, 0, 0 # cx, cy
    
    def ball_distance(self, angle):
        return 0