import cv2
import numpy as np
#import torch
#import model.detector
#import utils.utils
import time
import math
from imutils.video import WebcamVideoStream
from imutils.video import FPS

class Camera:
    def __init__(self):
        # 카메라 설정
        self.cam = WebcamVideoStream(-1).start()
        self.fps = FPS()
        shape = (self.height, self.width, _) = self.get_image().shape
        print(shape) # 세로, 가로 출력
        time.sleep(2)
        
        self.canny_min = 50
        self.canny_max = 150

        ## YOLO 설정
        #self.optData = "./Sensor/dataset/coco.data"
        #self.optWeight = "./Sensor/weights/ESWv5-290-epoch-0.341991ap-model.pth"
        #self.cfg = utils.utils.load_datafile(self.optData)
        #self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        #self.model = model.detector.Detector(self.cfg["classes"], self.cfg["anchor_num"], True).to(self.device)
        #self.model.load_state_dict(torch.load(self.optWeight, map_location=self.device))
        #self.model.eval()
    
    # 이미지 공급 쓰레드에서 이미지 하나 get.    
    def get_image(self):
        try:
            print("image get")
            return self.cam.read().copy()
        except AttributeError: # 이미지를 얻지 못할경우 검은화면 반환
            print("Attribute Error")
            return np.zeros(shape=(480, 640, 3), dtype="uint8")
    def nothing(self,x):
        pass
        
    def is_arrow(self, img):
        # 초기 트랙바 설정
        # 초기 트랙바 설정
        cv2.namedWindow("Simulator_Image", cv2.WINDOW_NORMAL)
        cv2.createTrackbar('low_H', 'Simulator_Image', 0, 360, self.nothing)
        cv2.createTrackbar('high_H', 'Simulator_Image', 33, 360, self.nothing)
        cv2.createTrackbar('low_L', 'Simulator_Image', 102, 255, self.nothing)
        cv2.createTrackbar('high_L', 'Simulator_Image', 255, 255, self.nothing)
        cv2.createTrackbar('low_S', 'Simulator_Image', 196, 255, self.nothing)
        cv2.createTrackbar('high_S', 'Simulator_Image', 255, 255, self.nothing)

        # 이미지를 HSV 색 공간으로 변환
        hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

        # 트랙바에서 HSV 범위 가져오기
        low_H = cv2.getTrackbarPos('low_H', 'Simulator_Image')
        high_H = cv2.getTrackbarPos('high_H', 'Simulator_Image')
        low_L = cv2.getTrackbarPos('low_L', 'Simulator_Image')
        high_L = cv2.getTrackbarPos('high_L', 'Simulator_Image')
        low_S = cv2.getTrackbarPos('low_S', 'Simulator_Image')
        high_S = cv2.getTrackbarPos('high_S', 'Simulator_Image')

        lower_yellow = np.array([low_H, low_L, low_S])
        upper_yellow = np.array([high_H, high_L, high_S])

        # 노란색 영역 추출
        yellow_mask = cv2.inRange(hsv, lower_yellow, upper_yellow)

        # 노란색 화살표만 컨투어 추출
        contours, _ = cv2.findContours(yellow_mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

        # 노란색 화살표를 그릴 빈 이미지 생성
        arrow_contour_img = np.zeros_like(img)

        # 노란색 화살표 컨투어를 그려서 arrow_contour_img에 추가
        for cnt in contours:
            # 윤곽선의 면적 구하기
            area = cv2.contourArea(cnt)

            # 면적이 너무 작으면 무시
            if area > 1000:  # 적절한 면적을 설정해야 합니다.
                continue

            # 윤곽선의 둘레 구하기
            perimeter = cv2.arcLength(cnt, True)

            # 윤곽선을 다각형으로 근사화
            approx = cv2.approxPolyDP(cnt, 0.02 * perimeter, True)

            # 다각형이 7개의 꼭지점을 가지면 화살표 모양일 가능성이 높음
            if len(approx) == 7:
                # 윤곽선 주변에 녹색 다각형 그리기
                cv2.drawContours(arrow_contour_img, [approx], -1, (0, 0, 255), 5)

        # 원본 이미지에 노란색 화살표 컨투어 추가
        result_img = cv2.add(img, arrow_contour_img)

        return result_img


    # 홀 인식
    def is_hole(self,img):
        
        # Setup BlobDetector
        detector = cv2.SimpleBlobDetector_create()
        params = cv2.SimpleBlobDetector_Params()
            
        # Filter by Area.
        params.filterByArea = True
        params.minArea = 400 #20000
        params.maxArea = 50000 #40000
            
        # Filter by Circularity
        params.filterByCircularity = True
        params.minCircularity = 0.5 #0.5
        
        # Filter by Convexity
        params.filterByConvexity = True
        params.minConvexity = 0.3
            
        # Filter by Inertia
        params.filterByInertia = True
        params.minInertiaRatio = 0.00001 #0.8

        # Distance Between Blobs
        params.minDistBetweenBlobs = 200 #200
            
        # Create a detector with the parameters
        detector = cv2.SimpleBlobDetector_create(params)

        cv2.namedWindow("Simulator_Image", cv2.WINDOW_NORMAL) 
        cv2.createTrackbar('low_H', 'Simulator_Image', 0, 360, self.nothing)
        cv2.createTrackbar('high_H', 'Simulator_Image', 30, 360, self.nothing)
        cv2.createTrackbar('low_L', 'Simulator_Image', 175, 255, self.nothing)
        cv2.createTrackbar('high_L', 'Simulator_Image', 255, 255, self.nothing)
        cv2.createTrackbar('low_S', 'Simulator_Image', 0, 255, self.nothing)
        cv2.createTrackbar('high_S', 'Simulator_Image', 255, 255, self.nothing)
        im=img
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
        return im
    
    # 벙커 인식
    def is_bunker(self, img):
        img_hls = cv2.cvtColor(img, cv2.COLOR_BGR2HLS)

        lower_bound = np.array([0, 135, 0])
        upper_bound = np.array([180, 255, 31])

        mask = cv2.inRange(img_hls, lower_bound, upper_bound)

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
    
    def cvCircleDetect(self, img):
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        
        circles = cv2.HoughCircles(gray, cv2.HOUGH_GRADIENT, 1, 100, param1=100, param2=40, minRadius=40, maxRadius=100)
        
        if np.any(circles == None):
            return False, img, None
        
        for i in circles[0]:
            cv2.circle(img, (i[0], i[1]), i[2], (255,255,255), 3)
        return True, img, (circles[0][0][0],circles[0][0][1])
    
    def yoloDetect(self, ori_img): # output is boxed img
        res_img = cv2.resize(ori_img, (self.cfg["width"], self.cfg["height"]), interpolation = cv2.INTER_LINEAR) 
        img = res_img.reshape(1, self.cfg["height"], self.cfg["width"], 3)
        img = torch.from_numpy(img.transpose(0,3, 1, 2))
        img = img.to(self.device).float() / 255.0
        
        preds = self.model(img)
        
        output = utils.utils.handel_preds(preds, self.cfg, self.device)
        output_boxes = utils.utils.non_max_suppression(output, conf_thres = 0.8, iou_thres = 0.5)
        
        LABEL_NAMES = []
        with open(self.cfg["names"], 'r') as f:
            for line in f.readlines():
                LABEL_NAMES.append(line.strip())
        h, w, _ = ori_img.shape
        scale_h, scale_w = h / self.cfg["height"], w / self.cfg["width"]
        
        for box in output_boxes[0]:
            box = box.tolist()       
            obj_score = box[4]
            category = LABEL_NAMES[int(box[5])]

            x1, y1 = int(box[0] * scale_w), int(box[1] * scale_h)
            x2, y2 = int(box[2] * scale_w), int(box[3] * scale_h)

            cv2.rectangle(ori_img, (x1, y1), (x2, y2), (255, 255, 0), 2)
            cv2.putText(ori_img, '%.2f' % obj_score, (x1, y1 - 5), 0, 0.7, (0, 255, 0), 2)	
            cv2.putText(ori_img, category, (x1, y1 - 25), 0, 0.7, (0, 255, 0), 2)
            return True, [x1, y1, x2, y2], ori_img
        return False, [False,False,False,False] , ori_img

if __name__ == "__main__":
    camera = Camera()
    #cv2.namedWindow("Hole Detection", cv2.WINDOW_NORMAL)
    while True:
        frame = camera.get_image()
        frame1 = frame.copy()
        frame2 = frame.copy()
        #cv2.namedWindow("Hole Detection", cv2.WINDOW_NORMAL)
        im = camera.is_hole(frame1)
        result_frame = camera.is_arrow(frame2)
        #ret, rect = camera.is_bunker(frame.copy())
        #if ret:
        #    cv2.rectangle(frame, (rect[0], rect[1]), (rect[0]+rect[2], rect[1]+rect[3]), (0,255,255), 2)
        #cv2.imshow("Frame", frame)
        #if cv2.waitKey(16) == ord("q"):
        #    break
        #ret, xy, output = camera.yoloDetect(frame.copy())
        cv2.imshow("detect", im)
        cv2.imshow("arrow", result_frame)
        if cv2.waitKey(16) == ord("q"):
            break
        
        
    cv2.destroyAllWindows()
