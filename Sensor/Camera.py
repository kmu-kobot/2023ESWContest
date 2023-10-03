import cv2
import numpy as np
import time
import sys
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
            return self.cam.read().copy()
        except AttributeError: # 이미지를 얻지 못할경우 검은화면 반환
            return np.zeros(shape=(480, 640, 3), dtype="uint8")
        
    def ball_position(self, img):
        return 0, 0, 0 # cx, cy
    
    def ball_distance(self, angle):
        return 0
    
    def is_hole(self,img):
        
        # Setup BlobDetector
        detector = cv2.SimpleBlobDetector_create()
        params = cv2.SimpleBlobDetector_Params()
            
        # Filter by Area.
        params.filterByArea = True
        params.minArea = 1100 #20000
        params.maxArea = 50000 #40000
            
        # Filter by Circularity
        params.filterByCircularity = True
        params.minCircularity = 0.5 #0.5
        
        # Filter by Convexity
        params.filterByConvexity = True
        params.minConvexity = 0.3
            
        # Filter by Inertia
        params.filterByInertia = True
        params.minInertiaRatio = 0.015 #0.8

        # Distance Between Blobs
        params.minDistBetweenBlobs = 200 #200
            
        # Create a detector with the parameters
        detector = cv2.SimpleBlobDetector_create(params)

        cv2.namedWindow("Simulator_Image", cv2.WINDOW_NORMAL) 
        cv2.createTrackbar('low_H', 'Simulator_Image', 0, 360, nothing)
        cv2.createTrackbar('high_H', 'Simulator_Image', 30, 360, nothing)
        cv2.createTrackbar('low_L', 'Simulator_Image', 175, 255, nothing)
        cv2.createTrackbar('high_L', 'Simulator_Image', 255, 255, nothing)
        cv2.createTrackbar('low_S', 'Simulator_Image', 0, 255, nothing)
        cv2.createTrackbar('high_S', 'Simulator_Image', 255, 255, nothing)

        
        while self.cam.isOpened():
            
            retval, im = self.cam.read()
            overlay = im.copy()

            # HSL 색상 범위를 트랙바를 사용하여 조절합니다.
            low_H = cv2.getTrackbarPos('low_H', 'Simulator_Image')
            high_H = cv2.getTrackbarPos('high_H', 'Simulator_Image')
            low_L = cv2.getTrackbarPos('low_L', 'Simulator_Image')
            high_L = cv2.getTrackbarPos('high_L', 'Simulator_Image')
            low_S = cv2.getTrackbarPos('low_S', 'Simulator_Image')
            high_S = cv2.getTrackbarPos('high_S', 'Simulator_Image')
        
            # Convert the image to HSV color space
            hsv = cv2.cvtColor(im, cv2.COLOR_BGR2HSV)
        
            # Define a range for yellow color in HSV
            lower_yellow = np.array([low_H, low_L, low_S])
            upper_yellow = np.array([high_H, high_L, high_S])
        
            # Create a mask to extract yellow regions
            mask = cv2.inRange(hsv, lower_yellow, upper_yellow)

            
            keypoints = detector.detect(im)
            for k in keypoints:
                cv2.circle(overlay, (int(k.pt[0]), int(k.pt[1])), int(k.size/2), (0, 0, 255), -1)
                cv2.line(overlay, (int(k.pt[0])-20, int(k.pt[1])), (int(k.pt[0])+20, int(k.pt[1])), (0,0,0), 3)
                cv2.line(overlay, (int(k.pt[0]), int(k.pt[1])-20), (int(k.pt[0]), int(k.pt[1])+20), (0,0,0), 3)

            opacity = 0.5
            cv2.addWeighted(overlay, opacity, im, 1 - opacity, 0, im)

            # Uncomment to resize to fit output window if needed
            #im = cv2.resize(im, None,fx=0.5, fy=0.5, interpolation = cv2.INTER_CUBIC)
            cv2.imshow("Output", im)

            k = cv2.waitKey(1) & 0xff
            if k == 27:
                break

        self.cam.release()
        cv2.destroyAllWindows()
