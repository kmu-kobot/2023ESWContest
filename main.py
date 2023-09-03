from Actuator.Motion import Motion
from Sensor.Camera import Camera

import cv2
import time

# Robot 클래스 import

if __name__ == "__main__":
    # ROBOT 객체 생성
    # robot = Robot()
    # 미션 수행 함수 실행
    # robot.line_tracing_Final()
    
    Motion = Motion()
    Camera = Camera()
    
    while True:
        frame = Camera.get_image()
        ret, img, xy = Camera.cvCircleDetect(frame)
        if ret == True:
            if xy[0] > 420:
                Motion.view("RIGHT")
            elif xy[0] < 220:
                Motion.view("LEFT")
        else:
            pass
        cv2.imshow('frame', img)
        if cv2.waitKey(16) & 0xFF == 27:
            break
        else:
            continue
    cv2.destroyAllWindows()
    
    # start = time.time()
    # end = start
    # while end-start < 0.5:
    #     end = time.time()
    #     Motion.TX_data_py3(11)
    # while end-start < 4:
    #     end = time.time()
    #     Motion.TX_data_py3(13)
    # while end-start < 6:
    #     end = time.time()
    #     Motion.TX_data_py3(11)
    # Motion.TX_data_py3(26)
        
    # main while loop
    # ceremony 완료할 때까지 반복