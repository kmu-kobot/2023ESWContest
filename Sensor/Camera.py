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
        params.minArea = 9000 #20000
        params.maxArea = 50000 #40000
            
        # Filter by Circularity
        params.filterByCircularity = True
        params.minCircularity = 0.05 #0.5
        
        # Filter by Convexity
        params.filterByConvexity = False
        #params.minConvexity = 0.87
            
        # Filter by Inertia
        params.filterByInertia = True
        params.minInertiaRatio = 0.1 #0.8

        # Distance Between Blobs
        params.minDistBetweenBlobs = 200 #200
            
        # Create a detector with the parameters
        detector = cv2.SimpleBlobDetector_create(params)

        while self.cam.isOpened():
            
            retval, im = self.cam.read()
            overlay = im.copy()

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
