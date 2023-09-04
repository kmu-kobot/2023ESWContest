import serial
import time
from threading import Thread

Motion = {"SIGNAL":{"INIT":26},
          "VIEW":{"LEFT90":17, "LEFT45":28,        # 목각도
                  "RIGHT90":27,"RIGHT45":30,
                  "CENTER":21},
          "WALK":{"LEFT70":14, "LEFT20":15,
                  "RIGHT70":13,"RIGHT20":20,       # 70연속, 20
                  "FORWARD":10,"BACKWARD":32,      # 종종 걸음
                  "GOFORWARD":11,"GOBACKWARD":32}, # 연속 걸음
          "SHOT":{"LEFT":2, "RIGHT":5},
          "TURN":{"LEFT10":4, "LEFT20":7, "LEFT45":22, "LEFT60":25,
                  "RIGHT10":6,"RIGHT20":9, "RIGHT45":24,"RIGHT60":19}
          }


class Motion:
    def __init__(self):
        self.serial_use = 1
        self.serial_port = None
        self.Read_RX = 0
        self.receiving_exit = 1
        self.threading_Time = 0.01
        self.lock = False
        self.distance = 0
        BPS = 4800  # 4800,9600,14400, 19200,28800, 57600, 115200

        # ---------local Serial Port : ttyS0 --------
        # ---------USB Serial Port : ttyAMA0 --------
        self.serial_port = serial.Serial('/dev/ttyS0', BPS, timeout=0.01)
        self.serial_port.flush()  # serial cls
        self.serial_t = Thread(target=self.Receiving, args=(self.serial_port,))
        self.serial_t.daemon = True
        self.serial_t.start()
        time.sleep(0.1)

    def TX_data_py2(self, one_byte):  # one_byte= 0~255
        self.lock = True
        self.serial_port.write(serial.to_bytes([one_byte]))  # python3
        time.sleep(0.01)
        
    def TX_data_py3(self, one_byte):  # one_byte= 0~255
        self.lock = True
        self.serial_port.write(serial.to_bytes([one_byte]))  # python3
        time.sleep(0.05)
        
    def RX_data(self):
        if self.serial_port.inWaiting() > 0:
            result = self.serial_port.read(1)
            RX = ord(result)
            return RX
        else:
            return 0

    def getRx(self):
        return self.lock

    def Receiving(self, ser):
        self.receiving_exit = 1
        while True:
            if self.receiving_exit == 0:
                break
            time.sleep(self.threading_Time)
            # 수신받은 데이터의 수가 0보다 크면 데이터를 읽고 출력
            while ser.inWaiting() > 0:
                # Rx, 수신
                result = ser.read(1)
                RX = ord(result)
                if RX == 200:
                # print("motion end")
                    self.lock = False
                # print("RX=" + str(RX))
                else:
                    self.distance = RX
                # -----  remocon 16 Code  Exit ------
                if RX == 16:
                    self.receiving_exit = 0
                    break
    

    # init 모션
    def init(self):
        if not self.lock:
            self.TX_data_py3(26)
            self.TX_data_py3(21)
            self.lock = False
        pass

    # 연속 걸음
    def walk(self):
        if not self.lock:
            self.TX_data_py3(Motion["WALK"]["GOFORWARD"])
        pass

    # 고개 돌려야하는 방향 입력 받아서 고개 좌우 회전
    def view(self, direction):
        if not self.lock:
            if direction == "CENTER":
                self.TX_data_py3(21)
            elif direction == "LEFT":
                self.TX_data_py3(28)
            elif direction == "RIGHT":
                self.TX_data_py3(30)
            self.lock = False
        pass