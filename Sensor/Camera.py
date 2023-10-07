import cv2
import numpy as np
import torch
import model.detector
import utils.utils
import time
import math
import threading
from imutils.video import WebcamVideoStream
from imutils.video import FPS

class CameraBufferCleanerThread(threading.Thread):
    def __init__(self, camera, name='camera-buffer-cleaner-thread'):
        self.camera = camera
        self.last_frame = None
        super(CameraBufferCleanerThread, self).__init__(name=name)
        self.start()

    def run(self):
        while True:
            ret, self.last_frame = self.camera.read()

class Camera:
    def __init__(self):
        # 카메라 설정
        self.cam = cv2.VideoCapture(0)
        self.cam_cleaner = CameraBufferCleanerThread(self.cam)
        
        self.fps = FPS()
        shape = (self.height, self.width, _) = self.get_image().shape
        print(shape) # 세로, 가로 출력
        time.sleep(2)

        # YOLO 설정
        self.optData = "./Sensor/data/coco.data"
        self.optWeight = "./Sensor/weights/ESWv6-290-epoch-0.924759ap-model.pth"
        self.cfg = utils.utils.load_datafile(self.optData)
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        self.model = model.detector.Detector(self.cfg["classes"], self.cfg["anchor_num"], True).to(self.device)
        self.model.load_state_dict(torch.load(self.optWeight, map_location=self.device))
        self.model.eval()
    
    # 이미지 공급 쓰레드에서 이미지 하나 get.    
    def get_image(self):
        try:
            print("image get")
            return self.cam_cleaner.last_frame
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

    def yoloDetect_master(self, ori_img):
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
        
        hole = golfBall = arrow = False
        holebox = golfBallBox = arrowBox = [False, False, False, False]
        for box in output_boxes[0]:
            box = box.tolist()       
            obj_score = box[4]
            category = LABEL_NAMES[int(box[5])]

            x1, y1 = int(box[0] * scale_w), int(box[1] * scale_h)
            x2, y2 = int(box[2] * scale_w), int(box[3] * scale_h)
            if category == "hall":
                hole = True
                holebox = [x1, y1, x2, y2]
            elif category == "golfBall":
                golfBall = True
                golfBallBox = [x1, y1, x2, y2]
            elif category == "arrow":
                arrow = True
                arrowBox = [x1, y1, x2, y2]
            # cv2.rectangle(ori_img, (x1, y1), (x2, y2), (255, 255, 0), 2)
            # cv2.putText(ori_img, '%.2f' % obj_score, (x1, y1 - 5), 0, 0.7, (0, 255, 0), 2)	
            # cv2.putText(ori_img, category, (x1, y1 - 25), 0, 0.7, (0, 255, 0), 2)
        return hole, holebox, golfBall, golfBallBox, arrow, arrowBox
    

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
        ret, xy, output = camera.yoloDetect(frame.copy())
        cv2.imshow("detect", output)
        if cv2.waitKey(16) == ord("q"):
            break
        
        
    cv2.destroyAllWindows()
