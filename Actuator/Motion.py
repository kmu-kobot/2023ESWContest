import serial
import time
from threading import Thread

'''
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
'''


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
                print(f"Receive: {RX}")
                if RX == 38:
                    self.lock = False
                    print("motion end --- lock 해제")
                # print("RX=" + str(RX))
                else:
                    self.distance = RX
                # -----  remocon 16 Code  Exit ------
                if RX == 16:
                    self.receiving_exit = 0
                    break
            if self.receiving_exit == 0:
                break


    # 초기 연결 확인 동작
    def initial(self):
        if not self.lock:
            self.TX_data_py3(250)
            while self.lock:
                continue
        return
        
    # init 모션
    def init(self):
        if not self.lock:
            self.TX_data_py3(26)
            while self.lock:
                continue
            self.TX_data_py3(21)
            while self.lock:
                continue
        pass

    # 연속 걸음
    def walk(self, period):
        if not self.lock:
            self.TX_data_py3(10)
            start_time = time.time()
            while self.lock:
                current_time = time.time()
                if current_time - start_time >= period:
                    break
            self.TX_data_py3(26)
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

    def neckup(self, count):
        if not self.lock:
            for _ in range(count):
                self.TX_data_py3(8)
                while self.lock:
                    continue
        return

    def neck65(self):
        if not self.lock:
            self.TX_data_py3(31)
            while self.lock:
                continue
        return
    
    def neck80(self):
        if not self.lock:
            self.TX_data_py3(29)
            while self.lock:
                continue
        return

if __name__ == '__main__':
    Motion = Motion()
    Motion.initial()
    time.sleep(5)

    Motion.init()
    time.sleep(1)
    pass
