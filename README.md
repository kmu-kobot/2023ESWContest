# 2023ESWContest
임베디드 소프트웨어 경진대회 지능형 휴머노이드 부문 ESW 오픈 1위

국민대학교 KOBOT

이족보행 로봇을 이용한 지능형 로봇 골프 대회 \
영상처리 및 로봇의 움직임 제어에 관련된 SW 개발

## 팀 구성

| 역할   | 이름    | 전공            | 담당                 |
|--------|---------|-----------------|--------------------|
| 팀장   | 이세현  | 소프트웨어학부 | 알고리즘 개발          |
| 팀원   | 안지한  | 기계공학부     | 동작, 하드웨어 관리    |
| 팀원   | 안선영  | 인공지능학부   | 영상처리               |
| 팀원   | 차예찬  | 인공지능학부   | 영상처리, 아이디어 개발 |
| 팀원   | 김준호  | 전자공학부     | 공 인식 영상처리       |

## 사용 기술

OpenCV, Python, bas

## 프로젝트 구조

  - **Actuator**
    - `Motion.py`: 휴머노이드 움직임 관리 파일
  - **Sensor**
    - `Camera.py`: 영상처리 파일
  - **Brain**
    - `Robot.py`: 미션에 필요한 변수를 관리하는 파일
    - `Robot_ball_distance.py`: 목 각도 별로 공과 로봇 사이 거리 계산.
  - `par3.py`: 파3 경기 인지, 판단, 제어
  - `par4.py`: 파4 경기 인지, 판단, 제어

  ### Main loop 구조
  ```plain_text
    ├── Imports
    ├── 초기 설정
    ├── 무한 루프 시작
    │   ├── 카메라에서 이미지 가져오기
    │   ├── 이미지 프로세싱 (Camera 클래스 활용)
    │   │   ├── 공 인식
    │   │   └── 기타 객체 인식
    │   ├── 상태 머신 (Finite State Machine)
    │   │   ├── FindBall
    │   │   ├── ApproachBall
    │   │   ├── ShortCheck
    │   │   ├── LongCheck
    │   │   ├── ApproachGoal
    │   │   ├── Shot
    │   │   └── Ceremony
    │   ├── 로봇 동작 (Motion 클래스 활용)
    │   │   ├── FindBall
    │   │   ├── ApproachBall
    │   │   ├── ShortCheck
    │   │   ├── LongCheck
    │   │   ├── ApproachGoal
    │   │   ├── Shot
    │   │   └── Ceremony
    │   ├── 현재 상태 및 목표 출력
    │   └── 화면에 프레임 표시
    └── 무한 루프 종료
  ```

## 주요 기능

### Motion.py

로봇의 동작을 제어하기 위한 Python 클래스인 `Motion`을 정의한다. 시리얼 통신을 통해 명령을 전송하고, 로봇의 움직임을 조작하는 기능이 구현되어 있다.

주요 메서드
- `TX_data_py3`: 데이터를 시리얼 통신으로 송신하는 메서드
- `RX_data`: 시리얼 포트로부터 데이터를 수신하는 메서드
- `getRx`: 데이터 수신 lock 상태를 반환하는 메서드
- `wait_unlock`: lock이 해제(동작 완료)될 때까지 대기하는 메서드
- `Receiving`: 백그라운드에서 계속해서 실행되는 데이터 수신 스레드
- 그 외 로봇 동작 제어 메서드 (init, walk, step, crab, neckup, turn, shot 등)

### Camera.py

카메라와 관련된 기능을 제공한다. 비디오 캡처와 영상처리 작업을 수행한다.

주요 기능
- `get_image`: 현재 프레임을 반환하는 메소드
- `hsvDetect`: HSV 색 공간을 기반으로 골프공을 검출하는 메소드
- `preprocess`: HSV 색 공간을 기반으로 홀과 화살표를 추출하는 메소드
- `is_hole`: 홀의 중심을 반환하는 메소드
- `holeDetect`: 거리와 밀도에 따라 홀을 검출하고 회전 각도를 계산
- `longChecker`: 홀의 위치 및 궤적을 계산하여 샷이 가능한지 판별하는 메소드
- `shortChecker`: 홀의 위치 및 공의 위치를 고려하여 홀 인을 판별하는 메소드

### Robot.py

로봇의 상태, 미션, 골프 공과의 거리, shot 가능 여부 등을 관리한다.

주요 변수
- `curr_mission`: 로봇이 현재 수행 중인 미션(state)
- `robot_ball_distance`: 로봇과 골프 공 간의 거리
- `neck_pitch`: 로봇의 목의 상하 각도
- `neck_yaw`: 로봇의 목의 좌우 각도
- `is_hole`, `is_ball`, `is_arrow`: 객체 검출 여부를 나타내는 boolean 변수

### Robot_ball_distance.py

로봇 목의 상하 각도와 카메라로 감지된 골프 공 bounding box 픽셀 값을 이용하여 공과 로봇 사이의 거리를 계산하는 메소드
