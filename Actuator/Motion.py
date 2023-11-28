import serial
import time
from threading import Thread

class Motion:
    def __init__(self):
        self.Read_RX = 0
        self.receiving_exit = 1
        self.threading_Time = 0.01
        self.lock = False
        self.distance = 0 # LIDAR 수신
        BPS = 4800  # 4800,9600,14400, 19200,28800, 57600, 115200

        # ---------local Serial Port : ttyS0 --------
        # ---------USB Serial Port : ttyAMA0 --------
        self.serial_port = serial.Serial('/dev/ttyS0', BPS, timeout=0.01)
        self.serial_port.flush()  # serial cls
        self.serial_t = Thread(target=self.Receiving, args=(self.serial_port,))
        self.serial_t.daemon = True # 스레드를 데몬 스레드로 설정 -> 프로그램이 종료될 때 함께 종료
        self.serial_t.start()
        time.sleep(0.1) # self.serial_t가 데이터를 수신하고 처리하는 동안 메인 스레드가 빠르게 종료되지 않도록 함 -> 메인 스레드 실행 시간 확보

    def TX_data_py2(self, one_byte):  # one_byte= 0~255
        self.lock = True
        self.serial_port.write(serial.to_bytes([one_byte]))  # python3
        time.sleep(0.1)
        
    def TX_data_py3(self, one_byte):  # one_byte= 0~255
        self.lock = True
        self.serial_port.write(serial.to_bytes([one_byte]))  # python3
        time.sleep(0.1)
        
    def RX_data(self):
        if self.serial_port.inWaiting() > 0:
            result = self.serial_port.read(1)
            RX = ord(result)
            return RX
        else:
            return 0

    def getRx(self):
        return self.lock

    def wait_unlock(self):
        while self.lock:
            continue
        
    # serial Thread에서 실행하는 함수 -> 백그라운드에서 계속 실행됨
    def Receiving(self, ser):
        self.receiving_exit = 1
        while True:
            time.sleep(self.threading_Time)
            # 수신받은 데이터의 수가 0보다 크면 데이터를 읽고 출력
            while ser.inWaiting() > 0:
                # Rx, 수신
                result = ser.read(1) # 시리얼 포트에서 한 바이트(문자)를 읽어와 result 변수에 저장
                RX = ord(result)
                if RX == 38:
                    self.lock = False
                # print("RX=" + str(RX))
                else:
                    self.distance = RX
                # -----  remocon 16 Code  Exit ------
                
            if self.receiving_exit == 0:
                break

    # 초기 연결 확인 동작
    def initial(self):
        self.TX_data_py3(250)
        self.wait_unlock()
        return
        
    # init 모션
    def init(self, neck=False):
        if neck:                 # 목 pitch = 100, yaw = 0
            self.TX_data_py3(8)
        else:                    # 목 조절 없음
            self.TX_data_py3(26)
        self.wait_unlock()
        return

    # 연속 걸음
    def walk(self, fast = False):
        if not fast:
            self.TX_data_py3(11)
        else:
            self.TX_data_py3(10)
        return

    # 한 걸음
    def step(self, direction="FRONT", stride="small"):
        if direction == "FRONT" and stride == "small":  # 앞으로 한 걸음
            self.TX_data_py3(36)
        elif direction == "FRONT" and stride == "big":  # 앞으로 2cm 한 걸음
            self.TX_data_py3(5)
        else:                                           # 뒤로 한 걸음
            self.TX_data_py3(39)
        self.wait_unlock()
        time.sleep(0.5)
        return

    # 좌우 게걸음
    def crab(self, direction):
        if direction == "LEFT":    # 왼쪽으로 한 걸음
            self.TX_data_py3(34)
        elif direction == "RIGHT": # 오른쪽으로 한 걸음
            self.TX_data_py3(33)
        self.wait_unlock()
        return

    # 고개 돌려야하는 각도 받아서 고개 좌우 회전
    def view(self, target_angle=0):
        if target_angle == 0:     # 정면
            self.TX_data_py3(21)
        elif target_angle == -45: # 왼쪽 45도
            self.TX_data_py3(28)
        elif target_angle == -90: # 왼쪽 90도
            self.TX_data_py3(17)
        elif target_angle == 45:  # 오른쪽 45도
            self.TX_data_py3(30)
        elif target_angle == 90:  # 오른쪽 90도
            self.TX_data_py3(27)
        self.wait_unlock()
        return

    # 고개 들어야하는 각도 받아서 고개 상하 조절
    def neckup(self, target_angle=100):
        serial_num = target_angle // 5 + 33
        self.TX_data_py3(serial_num)
        self.wait_unlock()
        return

    # 몸통 회전 LEFT, RIGHT 각각 5도, 10도, 20도, 45도, 60도
    def turn(self, direction="LEFT", angle=10):
        if direction == "LEFT":
            if angle == 5:       
                self.TX_data_py3(1)
            elif angle == 10:
                self.TX_data_py3(4)
            elif angle == 20:
                self.TX_data_py3(7)
            elif angle == 45:
                self.TX_data_py3(22)
            elif angle == 60:
                self.TX_data_py3(25)
        else:
            if angle == 5:       
                self.TX_data_py3(3)
            elif angle == 10:
                self.TX_data_py3(6)
            elif angle == 20:
                self.TX_data_py3(9)
            elif angle == 45:
                self.TX_data_py3(24)
            elif angle == 60:
                self.TX_data_py3(19)
        self.wait_unlock()
        return

    def eagle(self):
        self.TX_data_py3(89)
        self.wait_unlock()
        return
    
    # 공을 중심으로 원 궤도로 회전
    def circular_orbit(self, direction = "Left", leg_up = True):
        if leg_up and direction == "Left":
            self.TX_data_py3(29)
        elif not leg_up and direction == "Left":
            self.TX_data_py3(30)
        elif leg_up and direction == "Right":
            self.TX_data_py3(54)
        else:
            self.TX_data_py3(55)
        self.wait_unlock()
        return

    # 공을 중심으로 원 궤도로 작게 회전
    def circular_orbit_small(self, direction = "Left", angle = 5):
        if direction == "Left":
            # self.TX_data_py3(86)
            self.turn("RIGHT", angle)
            for _ in range(angle // 5):
                self.crab("LEFT")
        else:
            # self.TX_data_py3(87) # 비추
            self.turn("LEFT", angle)
            for _ in range(angle // 5):
                self.crab("RIGHT")
        self.wait_unlock()
        return
    
    # shot
    def shot(self, direction = "LEFT", speed = 8):
        if direction == "LEFT": # 57(약한 샷) ~ 67(강한 샷)
            motion_num = speed + 55
            self.TX_data_py3(motion_num) # default 세기 63
        else:
            if speed == 2:
                self.TX_data_py3(82)
            else:
                self.TX_data_py3(85) # 오른쪽으로 세게 치는 샷
        self.wait_unlock()
        return

    def ceremony(self):
        self.TX_data_py3(83)
        self.wait_unlock()
        return
    
if __name__ == '__main__':
    Motion = Motion()
    Motion.initial()
    time.sleep(7)
    pass
