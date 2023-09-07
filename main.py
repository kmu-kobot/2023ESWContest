from Actuator.Motion import Motion
from Sensor.Camera import Camera

import cv2
import numpy as np
import time

CONFIDENCE_THRESHOLD = 0.8
GREEN = (0, 255, 0)

# Robot 클래스 import

if __name__ == "__main__":
    # ROBOT 객체 생성
    # robot = Robot()
    # 미션 수행 함수 실행
    # robot.line_tracing_Final()
    
    Motion = Motion()
    Camera = Camera()
    
    direction = "CENTER"

    Motion.init()
    
    while True:
        frame = Camera.get_image()

        # run the YOLO model on the frame
        detections = Camera.yoloDetect(frame.copy())

        # loop over the detections
        for data in detections.boxes.data.tolist():
            # extract the confidence (i.e., probability) associated with the detection
            confidence = data[4]

            # filter out weak detections by ensuring the
            # confidence is greater than the minimum confidence
            if float(confidence) < CONFIDENCE_THRESHOLD:
                continue

            # if the confidence is greater than the minimum confidence,
            # draw the bounding box on the frame
            xmin, ymin, xmax, ymax = int(data[0]), int(data[1]), int(data[2]), int(data[3])
            cv2.rectangle(frame, (xmin, ymin), (xmax, ymax), GREEN, 2)

        # show the frame to our screen
        cv2.imshow("Frame", frame)
        if cv2.waitKey(1600) == ord("q"):
            break
        
    cv2.destroyAllWindows()

    # ret, img, xy = Camera.cvCircleDetect(frame)
    # if ret == True:
    #     if xy[0] > 420: # 화면의 오른쪽
    #         if direction == "CENTER":
    #             Motion.view("RIGHT")
    #             direction = "RIGHT"
    #         elif direction == "LEFT":
    #             Motion.view("CENTER")
    #             direction = "CENTER"
    #     elif xy[0] < 220: # 화면의 왼쪽
    #         if direction == "CENTER":
    #             Motion.view("LEFT")
    #             direction = "LEFT"
    #         elif direction == "RIGHT":
    #             Motion.view("CENTER")
    #             direction = "CENTER"
    # else:
    #     pass
    # cv2.imshow('frame', img)
    # if cv2.waitKey(16) & 0xFF == 27:
    #     break
    # else:
    #     continue
        
    # main while loop
    # ceremony 완료할 때까지 반복