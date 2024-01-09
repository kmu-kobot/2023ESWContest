'******** 2족 보행로봇 초기 영점 프로그램 ********

DIM I AS BYTE
DIM J AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM 보행속도 AS BYTE
DIM 좌우속도 AS BYTE
DIM 좌우속도2 AS BYTE
DIM 보행순서 AS BYTE
DIM 현재전압 AS BYTE
DIM 반전체크 AS BYTE
DIM 모터ONOFF AS BYTE
DIM 자이로ONOFF AS BYTE
DIM 기울기앞뒤 AS INTEGER
DIM 기울기좌우 AS INTEGER

DIM 곡선방향 AS BYTE

DIM 넘어진확인 AS BYTE
DIM 기울기확인횟수 AS BYTE
DIM 보행횟수 AS BYTE
DIM 보행COUNT AS BYTE

DIM 적외선거리값  AS BYTE

DIM S11  AS BYTE
DIM S16  AS BYTE
'************************************************
DIM NO_0 AS BYTE
DIM NO_1 AS BYTE
DIM NO_2 AS BYTE
DIM NO_3 AS BYTE
DIM NO_4 AS BYTE

DIM NUM AS BYTE

DIM BUTTON_NO AS INTEGER
DIM SOUND_BUSY AS BYTE
DIM TEMP_INTEGER AS INTEGER

'**** 기울기센서포트 설정 ****
CONST 앞뒤기울기AD포트 = 0
CONST 좌우기울기AD포트 = 1
CONST 기울기확인시간 = 20  'ms

CONST 적외선AD포트  = 4


CONST min = 61	'뒤로넘어졌을때
CONST max = 107	'앞으로넘어졌을때
CONST COUNT_MAX = 3


CONST 머리이동속도 = 10
'************************************************



PTP SETON 				'단위그룹별 점대점동작 설정
PTP ALLON				'전체모터 점대점 동작 설정

DIR G6A,1,0,0,1,0,0		'모터0~5번
DIR G6D,0,1,1,0,1,1		'모터18~23번
DIR G6B,1,1,1,1,1,1		'모터6~11번
DIR G6C,0,0,0,1,1,0		'모터12~17번

'************************************************

OUT 52,0	'머리 LED 켜기
'***** 초기선언 '************************************************

보행순서 = 0
반전체크 = 0
기울기확인횟수 = 0
보행횟수 = 1
모터ONOFF = 0

'****초기위치 피드백*****************************


'TEMPO 230
'MUSIC "cdefg"
'MUSIC "gfedc"


SPEED 5
GOSUB MOTOR_ON

S11 = MOTORIN(11)
S16 = MOTORIN(16)

SERVO 11, 100
SERVO 16, S16

SERVO 16, 100


GOSUB 전원초기자세
GOSUB 기본자세


GOSUB 자이로INIT
GOSUB 자이로MID
GOSUB 자이로ON



'PRINT "VOLUME 200 !"
'PRINT "SOUND 12 !" '안녕하세요

'GOSUB All_motor_mode3





GOTO MAIN	'시리얼 수신 루틴으로 가기

'************************************************

'*********************************************
' Infrared_Distance = 60 ' About 20cm
' Infrared_Distance = 50 ' About 25cm
' Infrared_Distance = 30 ' About 45cm
' Infrared_Distance = 20 ' About 65cm
' Infrared_Distance = 10 ' About 95cm
'*********************************************
'************************************************
시작음:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
종료음:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
에러음:
    TEMPO 250
    MUSIC "FFF"
    RETURN
    '************************************************
    '************************************************
MOTOR_ON: '전포트서보모터사용설정

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    모터ONOFF = 0
    GOSUB 시작음			
    RETURN

    '************************************************
    '전포트서보모터사용설정
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    모터ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB 종료음	
    RETURN
    '************************************************
    '위치값피드백
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,1,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
    '위치값피드백
MOTOR_SET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,1,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
All_motor_Reset:

    MOTORMODE G6A,1,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1,1
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,1,1

    RETURN
    '************************************************
All_motor_mode2:

    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,2,2

    RETURN
    '************************************************
All_motor_mode3:

    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,3,3

    RETURN
    '************************************************
Leg_motor_mode1:
    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    RETURN
    '************************************************
Leg_motor_mode2:
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    RETURN

    '************************************************
Leg_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    RETURN
    '************************************************
Leg_motor_mode4:
    MOTORMODE G6A,3,2,2,1,3
    MOTORMODE G6D,3,2,2,1,3
    RETURN
    '************************************************
Leg_motor_mode5:
    MOTORMODE G6A,3,2,2,1,2
    MOTORMODE G6D,3,2,2,1,2
    RETURN
    '************************************************
Arm_motor_mode1:
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,1,1
    RETURN
    '************************************************
Arm_motor_mode2:
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,2,2
    RETURN

    '************************************************
Arm_motor_mode3:
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,3,3
    RETURN
    '************************************************

전원초기자세:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90, 190
    WAIT
    mode = 0
    RETURN
    '************************************************
안정화자세:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90, 190
    WAIT
    mode = 0

    RETURN
    '******************************************	


    '************************************************
기본자세:


    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    SERVO 11, 100
    'SERVO 16, 100
    WAIT
    mode = 0

    RETURN
    '******************************************	
기본자세2:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    mode = 0
    RETURN
    '******************************************	
기본자세3:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT
    SERVO 11, 100
    SERVO 16, 60
    mode = 0
    RETURN

    '******************************************	
차렷자세:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT
    mode = 2
    RETURN
    '******************************************
앉은자세:
    GOSUB 자이로OFF
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT
    mode = 1

    RETURN
    '******************************************
    '***********************************************
    '***********************************************
    '**** 자이로감도 설정 ****
자이로INIT:

    GYRODIR G6A, 0, 0, 1, 0,0
    GYRODIR G6D, 1, 0, 1, 0,0

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
    '**** 자이로감도 설정 ****
자이로MAX:

    GYROSENSE G6A,250,180,30,180,0
    GYROSENSE G6D,250,180,30,180,0

    RETURN
    '***********************************************
자이로MID:

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
자이로MIN:

    GYROSENSE G6A,200,100,30,100,0
    GYROSENSE G6D,200,100,30,100,0
    RETURN
    '***********************************************
자이로ON:

    GYROSET G6A, 4, 3, 3, 3, 0
    GYROSET G6D, 4, 3, 3, 3, 0

    자이로ONOFF = 1

    RETURN
    '***********************************************
자이로OFF:

    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0


    자이로ONOFF = 0
    RETURN

    '************************************************

    '******************************************
    '**********************************************
    '**********************************************
RX_EXIT:

    ERX 4800, A, MAIN

    GOTO RX_EXIT
    '**********************************************
GOSUB_RX_EXIT:

    ERX 4800, A, GOSUB_RX_EXIT2

    GOTO GOSUB_RX_EXIT

GOSUB_RX_EXIT2:
    RETURN
    '**********************************************
전진_한걸음:
    보행COUNT = 0
    보행속도 = 13
    좌우속도 = 4
    넘어진확인 = 0

    GOSUB Leg_motor_mode3
    SPEED 7

    MOVE G6A, 100,  77, 145,  96, 100,
    MOVE G6D, 100,  77, 145,  96, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    MOVE G6A,  94,  76, 145,  93, 105,
    MOVE G6D, 106,  76, 145,  93,  96,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6A,  91,  80, 130, 108, 110,
    MOVE G6D, 111,  78, 145,  97,  96,
    MOVE G6B,  80,  40,  80,  ,  ,
    MOVE G6C, 115,  30,  80,  ,  ,
    WAIT

    '오른발 내리기
    MOVE G6A, 100,  55, 145, 125, 100,
    MOVE G6D, 100,  89, 120, 115, 100,
    MOVE G6B,  95,  30,  80,  ,  ,
    MOVE G6C, 110,  30,  80,  ,  ,
    WAIT
    DELAY 200


    MOVE G6A, 105,  67, 130, 127, 100,
    MOVE G6D,  95,  96, 115, 113, 100,
    MOVE G6B, 120,  30,  80,  ,  ,
    MOVE G6C, 105,  30,  80,  ,  ,
    WAIT

    'SPEED 6
    MOVE G6A, 114,  74, 130, 127,  98,
    MOVE G6D,  85,  81, 125, 118, 115,
    MOVE G6B, 130,  30,  80,  ,  ,
    MOVE G6C,  95,  30,  80,  ,  ,
    WAIT

    MOVE G6A, 113,  89, 105, 137,  98,
    MOVE G6D,  90,  81, 105, 139, 107,
    MOVE G6B, 120,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT



    SPEED 3
    MOVE G6A, 100,  77, 145,  96, 100,
    MOVE G6D, 100,  77, 145,  96, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT
    GOTO RX_EXIT
    '*******************************
gofoward_H1:
    GOSUB All_motor_mode3
    'GOSUB Leg_motor_mode3
    '오른발로 무게중심

    SPEED 8

    MOVE G6A,  97,  74, 145, 100, 103,
    MOVE G6D, 103,  79, 135, 104, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    SPEED 5
    MOVE G6A,  86,  79, 141,  97, 111,
    MOVE G6D, 110,  76, 146,  93,  99,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  32,  81,  ,  ,
    WAIT

    MOVE G6A,  83,  76, 141,  99, 111,
    MOVE G6D, 112,  86, 136,  92,  99,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  32,  81,  ,  ,
    WAIT

    MOVE G6A,  98,  68, 138, 116, 101,
    MOVE G6D, 102,  78, 139, 104, 101,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  33,  82,  ,  ,
    WAIT

    DELAY 200
    '한발 내딛기 완성
    MOVE G6A, 108,  68, 138, 116, 101,
    MOVE G6D,  92,  78, 139, 104, 101,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  33,  82,  ,  ,
    WAIT

    MOVE G6A, 114,  93, 114, 114,  99,
    MOVE G6D,  81,  95, 113, 109, 113,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    'SPEED 5
    GOSUB 기본자세2
    RETURN

    '**********************************************
gofoward_H2:
    GOSUB All_motor_mode3
    'GOSUB Leg_motor_mode3
    '오른발로 무게중심

    SPEED 3
    '오른발 무게중심
    MOVE G6A,  94,  74, 145, 100, 101,
    MOVE G6D, 106,  79, 135, 104, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT
    '오른발 무게중심 + 왼발 들기
    SPEED 5
    MOVE G6A,  88,  78, 141,  97, 111,
    MOVE G6D, 112,  78, 146,  93,  99,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  32,  81,  ,  ,
    WAIT

    SPEED 3
    '무게중심 중앙 + 왼발 내딛기완성
    MOVE G6A,  98,  68, 138, 114, 102,
    MOVE G6D, 102,  78, 139, 102, 101,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  33,  82,  ,  ,
    WAIT

    DELAY 95
    '왼발 내딛기 + 무게중심 왼발
    MOVE G6A, 108,  70, 138, 116, 101,
    MOVE G6D,  92,  80, 139, 104, 103,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  33,  82,  ,  ,
    WAIT

    SPEED 5
    '왼발 무릎 굽히기 + 오른발 앞으로 끌고오기(동일선상)
    MOVE G6A, 114,  94, 114, 114,  99,
    MOVE G6D,  84,  89, 113, 112, 113,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    SPEED 3
    GOSUB 기본자세2
    RETURN

    '**********************************************

느린연속전진_골프:
    보행COUNT = 0
    보행속도 = 8
    좌우속도 = 4
    넘어진확인 = 0

    GOSUB Leg_motor_mode3


    SPEED 4
    '오른발에 무게중심
    MOVE G6A, 88,  74, 144,  95, 110
    MOVE G6D,108,  76, 146,  93,  96
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    SPEED 8'
    '오른발 무게중심 + 왼발들기good
    MOVE G6A,  92,  93, 120, 106, 110,
    MOVE G6D, 111,  77, 147,  94,  96,
    MOVE G6B,  90,  30,  80,  ,  ,
    MOVE G6C, 110,  30,  80,  ,  ,
    WAIT

    GOTO 느린연속전진_골프_1
    '***************************************************

느린연속전진_골프_1:
    GOSUB Leg_motor_mode3
    ETX 4800,11 '진행코드를 보냄
    SPEED 보행속도
    '오른발 무게중심 + 왼발 내리기(애매하게 들림)
    MOVE G6A,  93,  59, 145, 115, 107,
    MOVE G6D, 102,  76, 147,  95,  96,
    WAIT


    SPEED 좌우속도
    'GOSUB Leg_motor_mode3
    '왼발 내림 + 왼발 무게중심 + 오른발 들기(애매)
    MOVE G6A, 106,  64, 144, 115,  96,
    MOVE G6D,  90,  80, 145,  95, 109,
    WAIT

    MOVE G6A, 114,  69, 144, 115,  96,
    MOVE G6D,  87,  82, 130, 110, 116,
    WAIT

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 느린연속전진_골프_2
    IF A = 11 THEN
        GOTO 느린연속전진_골프_2
    ELSE
        ' GOSUB Leg_motor_mode3

        MOVE G6A,112,  76, 146,  93, 96,100
        MOVE G6D,90, 100, 100, 115, 110,100
        MOVE G6B,110
        MOVE G6C,90
        WAIT
        HIGHSPEED SETOFF

        SPEED 8
        MOVE G6A, 106,  76, 146,  93,  96,100		
        MOVE G6D,  88,  71, 152,  91, 106,100
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 2
        GOSUB 기본자세2

        GOTO RX_EXIT
    ENDIF
    '**********

느린연속전진_골프_2:
    '왼발 무게중심 + 오른발 앞으로 가져오기(든상태)
    GOSUB Leg_motor_mode3
    MOVE G6A, 114,  72, 147,  104,  96,
    MOVE G6D,  88,  83, 120, 114, 115,
    MOVE G6B, 110,  30,  80,  ,  ,
    MOVE G6C,  90,  30,  83,  ,  ,
    WAIT


느린연속전진_골프_3:
    ETX 4800,11 '진행코드를 보냄

    SPEED 보행속도

    MOVE G6A, 102,  83, 138, 101,  96,
    MOVE G6D,  98,  58, 145, 119, 107,
    WAIT



    '오른발 내리기 + 오른발 무게중심+왼발들기
    SPEED 좌우속도
    MOVE G6A,  97,  83, 138, 101, 100,
    MOVE G6D, 105,  58, 145, 119, 101,
    WAIT


    MOVE G6A,  90,  83, 130, 110, 116,
    MOVE G6D, 110,  69, 144, 115,  96,
    WAIT

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 느린연속전진_골프_4
    IF A = 11 THEN
        GOTO 느린연속전진_골프_4
    ELSE

        MOVE G6A, 90, 100, 100, 115, 110,100
        MOVE G6D,112,  76, 146,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110
        WAIT
        HIGHSPEED SETOFF
        SPEED 8

        MOVE G6D, 106,  76, 146,  93,  96,100		
        MOVE G6A,  88,  71, 152,  91, 106,100
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT	
        SPEED 2
        GOSUB 기본자세2

        GOTO RX_EXIT
    ENDIF

느린연속전진_골프_4:
    GOSUB Leg_motor_mode3
    '오른발 무게중심 + 왼발 앞으로 가져오기(들고있음 + ㄱㅊ)
    MOVE G6A,  88,  94, 120, 105, 114,
    MOVE G6D, 112,  78, 146,  94,  98,
    MOVE G6B,  90,  30,  80,  ,  ,
    MOVE G6C, 110,  30,  83,  ,  ,
    WAIT

    GOTO 느린연속전진_골프_1

    '**********************************************

연속전진_골프:
    보행COUNT = 0
    보행속도 = 18
    좌우속도 = 4
    넘어진확인 = 0

    GOSUB Leg_motor_mode3
    SPEED 4

    MOVE G6D,  88,  74, 144,  95, 110
    MOVE G6A, 107,  76, 146,  93,  96
    MOVE G6C, 100
    MOVE G6B, 100
    WAIT

    SPEED 10


    GOTO 연속전진_골프_2	


    '***************************************************

연속전진_골프_1:

    ETX 4800,11 '진행코드를 보냄
    SPEED 보행속도

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT


    SPEED 좌우속도
    GOSUB Leg_motor_mode3

    'MOVE G6A,110,  76, 147, 93,  96
    MOVE G6A,112,  76, 147, 95,  96
    MOVE G6D,92, 94, 145,  71, 112
    WAIT

    SPEED 9
    MOVE G6A,113,  76, 147, 95,  96
    MOVE G6D,90, 86, 145,  80, 112
    WAIT


    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 연속전진_골프_2
    IF A = 11 THEN
        GOTO 연속전진_골프_2
    ELSE
        ' GOSUB Leg_motor_mode3

        MOVE G6A,112,  76, 146,  93, 96,100
        MOVE G6D,90, 100, 100, 115, 110,100
        MOVE G6B,110
        MOVE G6C,90
        WAIT
        HIGHSPEED SETOFF

        SPEED 8
        MOVE G6A, 106,  76, 146,  93,  96,100		
        MOVE G6D,  88,  71, 152,  91, 106,100
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 2
        GOSUB 기본자세2

        GOTO RX_EXIT
    ENDIF
    '**********

연속전진_골프_2:
    SPEED 10

    'MOVE G6D, 92, 85, 120, 105, 111,100
    MOVE G6D, 92, 87, 120, 102, 111
    MOVE G6A,111,  76, 147,  95,  96,100
    MOVE G6C,90
    MOVE G6B,110
    WAIT


    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

연속전진_골프_3:
    ETX 4800,11 '진행코드를 보냄

    SPEED 보행속도

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 연속전진_골프_4
    IF A = 11 THEN
        GOTO 연속전진_골프_4
    ELSE

        MOVE G6A, 90, 100, 100, 115, 110,100
        MOVE G6D,112,  76, 146,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110
        WAIT
        HIGHSPEED SETOFF
        SPEED 8

        MOVE G6D, 106,  76, 146,  93,  96,100		
        MOVE G6A,  88,  71, 152,  91, 106,100
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT	
        SPEED 2
        GOSUB 기본자세2

        GOTO RX_EXIT
    ENDIF

연속전진_골프_4:
    '왼발들기10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    GOTO 연속전진_골프_1
    '*******************************

    '************************************************
연속후진_골프:
    넘어진확인 = 0
    보행속도 = 8
    좌우속도 = 4
    GOSUB Leg_motor_mode3



    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 4
        MOVE G6A, 88,  71, 152,  91, 110
        MOVE G6D,108,  76, 145,  93,  96
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        SPEED 10
        MOVE G6A, 90, 100, 100, 115, 110
        MOVE G6D,110,  76, 145,  93,  96
        MOVE G6B,90
        MOVE G6C,110
        WAIT

        GOTO 연속후진_골프_1	
    ELSE
        보행순서 = 0

        SPEED 4
        MOVE G6D,  85,  71, 152,  91, 110
        MOVE G6A, 108,  76, 146,  93,  96
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT

        SPEED 10
        MOVE G6D, 90, 100, 100, 115, 110
        MOVE G6A,112,  76, 146,  93,  96
        MOVE G6C,90
        MOVE G6B,110
        WAIT


        GOTO 연속후진_골프_2

    ENDIF

    '*************************************
goback_H1:
    GOSUB All_motor_mode3
    GOSUB Leg_motor_mode3	
    SPEED 4
    보행속도 = 12
    좌우속도 = 4
    '오른발로 무게중심
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 145,  93,  96
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    '연속후진_골프: 왼발들기
    SPEED 10
    MOVE G6A, 95, 96, 100, 115, 110
    MOVE G6D,110,  76, 145,  93,  96
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    '연속후진_골프_1: 왼발내림
    SPEED 보행속도

    MOVE G6D,110,  76, 146, 93,  96
    MOVE G6A,90, 98, 146,  69, 110
    WAIT

    SPEED 좌우속도
    MOVE G6D, 90,  60, 137, 120, 110
    MOVE G6A,107,  85, 137,  93,  96
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF


    SPEED 11

    MOVE G6D,90, 90, 120, 105, 110
    MOVE G6A,112,  76, 146,  93, 96
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 8
    MOVE G6A, 106,  76, 146,  93,  96,100		
    MOVE G6D,  88,  71, 152,  91, 106,100
    MOVE G6B, 100
    MOVE G6C, 100
    WAIT	

    SPEED 2
    GOSUB 기본자세2

    RETURN
    '*************************************
연속후진_골프_1:
    ETX 4800,12 '진행코드를 보냄
    SPEED 보행속도

    MOVE G6D,110,  76, 146, 93,  96
    MOVE G6A,90, 98, 146,  69, 110
    WAIT

    SPEED 좌우속도
    MOVE G6D, 90,  60, 137, 120, 110
    MOVE G6A,107,  85, 137,  93,  96
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF


    SPEED 11

    MOVE G6D,90, 90, 120, 105, 110
    MOVE G6A,112,  76, 146,  93, 96
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    ERX 4800,A, 연속후진_골프_2
    IF A <> A_old THEN
연속후진_골프_1_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6A, 108,  76, 146,  93,  96		
        MOVE G6D,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB 기본자세2
        GOTO RX_EXIT
    ENDIF
    '**********

연속후진_골프_2:
    ETX 4800,12 '진행코드를 보냄
    SPEED 보행속도
    MOVE G6A,112,  76, 146, 93,  96
    MOVE G6D,90, 98, 146,  69, 110
    WAIT


    SPEED 좌우속도
    MOVE G6A, 90,  60, 137, 120, 110
    MOVE G6D,107  85, 137,  93,  96
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF


    SPEED 11
    MOVE G6A,90, 90, 120, 105, 110
    MOVE G6D,110,  76, 146,  93,  96
    MOVE G6B, 90
    MOVE G6C,110
    WAIT


    ERX 4800,A, 연속후진_골프_1
    IF A <> A_old THEN
연속후진_골프_2_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6D, 106,  76, 146,  93,  96		
        MOVE G6A,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB 기본자세2
        GOTO RX_EXIT
    ENDIF  	

    GOTO 연속후진_골프_1
    '******************************************
전진종종걸음_골프:
    GOSUB All_motor_mode3
    보행COUNT = 0
    SPEED 6
    HIGHSPEED SETON

    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6D,106,  76, 147,  93, 98
    MOVE G6B,90
    MOVE G6C,100
    WAIT
    DELAY 10
    GOTO 전진종종걸음_골프_1

    '**********************

전진종종걸음_골프_1:
    'MOVE G6A,92,  88, 125, 100, 104
    'MOVE G6D,109,  78, 146,  93,  104
    'MOVE G6B, 70, 30, 81, , ,
    'MOVE G6C,110
    'WAIT
    'DELAY 10

    MOVE G6A,92,  90, 125, 100, 104
    MOVE G6D,109,  82, 140,  97,  104
    MOVE G6B, 70, 30, 81, , ,
    MOVE G6C,110
    WAIT
    DELAY 10


전진종종걸음_골프_2:

    MOVE G6A,104,   73, 140, 103,  100
    MOVE G6D, 97,  83, 146,  85, 102
    WAIT
    DELAY 10

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    'IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음_골프_2_stop

    ERX 4800,A, 전진종종걸음_골프_4
    IF A <> A_old THEN
전진종종걸음_골프_2_stop:
        MOVE G6D,93,  90, 125, 95, 104
        MOVE G6A,107,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

전진종종걸음_골프_4:	
    MOVE G6D,93,  74, 140, 100, 106
    MOVE G6A,109,  78, 146,  92,  100
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    DELAY 5

전진종종걸음_골프_5:
    MOVE G6D,101,  74, 140, 103,  100
    MOVE G6A, 97,  85, 144,  87, 102
    WAIT
    DELAY 5

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    ERX 4800,A, 전진종종걸음_골프_1
    IF A <> A_old THEN
전진종종걸음_골프_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*************************************

    GOTO 전진종종걸음_골프_1
    '**********************
gofoward_LL2:
    GOSUB All_motor_mode3
    'GOSUB Leg_motor_mode3
    SPEED 8
    'HIGHSPEED SETON

    '오른발로 무게중심

    MOVE G6A,  95,  76, 145,  98, 100,
    MOVE G6D, 105,  79, 138, 101, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    DELAY 20

    MOVE G6A,  92,  76, 145,  98, 103,
    MOVE G6D, 108,  79, 135, 104, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    DELAY 20

    '전진종종걸음_골프_1: 왼발들기

    MOVE G6A,  90,  83, 139,  95, 109,
    MOVE G6D, 109,  76, 146,  93, 104,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  32,  81,  ,  ,
    WAIT

    DELAY 50

    MOVE G6A,  90,  78, 136, 100, 109,
    MOVE G6D, 109,  76, 146,  93, 104,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  32,  81,  ,  ,
    WAIT

    DELAY 100

    MOVE G6A,  75,  73, 141, 105, 119,
    MOVE G6D, 114,  76, 146,  93,  94,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  32,  81,  ,  ,
    WAIT



    SPEED 5
    MOVE G6A,  98,  73, 138, 106, 101,
    MOVE G6D, 102,  78, 139,  99, 101,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  33,  82,  ,  ,
    WAIT


    DELAY 200

    SPEED 8
    MOVE G6A, 105,  75, 134, 113, 102,
    MOVE G6D,  95,  80, 139, 102, 104,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  33,  82,  ,  ,
    WAIT

    MOVE G6A, 112,  73, 134, 119,  99,
    MOVE G6D,  86,  95, 113, 113, 113,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  33,  82,  ,  ,
    WAIT

    SPEED 5

    MOVE G6A, 112,  93, 114, 114,  99,
    MOVE G6D,  86,  95, 113, 109, 113,
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    GOSUB 기본자세2

    RETURN
    '**********************
gofoward_LL3:
    GOSUB All_motor_mode3
    'GOSUB Leg_motor_mode3
    '오른발로 무게중심

    SPEED 5
    '오른발 무게심중
    MOVE G6A,  97,  74, 145, 100, 103,
    MOVE G6D, 103,  79, 135, 104, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT
    '오른발 무게중심 + 왼발 살짝들기
    MOVE G6A,  89,  79, 135, 100, 111,
    MOVE G6D, 110,  77, 146,  93,  99,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  32,  81,  ,  ,
    WAIT
    SPEED 4
    '오른발 무게중심 + 오른발 무릎을 굽혀서 왼발거의 착지
    MOVE G6A,  86,  75, 141,  96, 111,
    MOVE G6D, 112,  87, 136,  95,  99,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  32,  81,  ,  ,
    WAIT

    SPEED 5
    '무게중 거의  가운데 + 왼발 완벽 착지
    MOVE G6A,  98,  73, 138, 106, 101,
    MOVE G6D, 102,  78, 139,  99, 101,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  33,  82,  ,  ,
    WAIT


    DELAY 200
    '한발 내딛기 완성
    'SPEED 8
    MOVE G6A, 105,  75, 134, 113, 102,
    MOVE G6D,  95,  80, 139, 102, 104,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  33,  82,  ,  ,
    WAIT

    MOVE G6A, 114,  75, 134, 119,  99,
    MOVE G6D,  85,  98, 113, 113, 113,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  33,  82,  ,  ,
    WAIT


    SPEED 5
    MOVE G6A, 113,  97, 114, 109,  97,
    MOVE G6D,  90, 100, 103, 110, 109,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    SPEED 5
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    'SPEED 5
    GOSUB 기본자세2
    RETURN
    '**********************
gofoward_LL4:
    GOSUB All_motor_mode3
    'GOSUB Leg_motor_mode3
    '오른발로 무게중심

    SPEED 3
    '오른발 무게중심
    MOVE G6A,  94,  74, 145, 100, 101,
    MOVE G6D, 106,  79, 135, 104, 100,
    MOVE G6B, 85,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT
    '오른발 무게중심 + 왼발 들기
    SPEED 5
    MOVE G6A,  88,  78, 141,  93, 111,
    MOVE G6D, 112,  78, 146,  93,  99,
    MOVE G6B,  75,  40,  81,  ,  ,
    MOVE G6C, 105,  32,  81,  ,  ,
    WAIT

    SPEED 3
    '무게중심 중앙 + 왼발 내딛기완성
    MOVE G6A,  98,  71, 138, 112, 102,
    MOVE G6D, 102,  78, 139, 104, 101,
    MOVE G6B,  80,  30,  81,  ,  ,
    MOVE G6C, 110,  33,  82,  ,  ,
    WAIT

    DELAY 95
    '왼발 내딛기 + 무게중심 왼발
    MOVE G6A, 112,  75, 138, 110, 101,
    MOVE G6D,  90,  76, 139, 104, 106,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 105,  33,  82,  ,  ,
    WAIT

    SPEED 5
    '왼발 무릎 굽히기 + 오른발 앞으로 끌고오기(동일선상)
    MOVE G6A, 114,  95, 114, 112,  99,
    MOVE G6D,  83,  95, 113, 109, 113,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    SPEED 3
    GOSUB 기본자세2
    RETURN


    '**********************
gofoward_LL1:
    GOSUB All_motor_mode3
    SPEED 12
    'HIGHSPEED SETON

    '오른발로 무게중심
    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    MOVE G6A,  97,  78, 147,  93, 104,
    MOVE G6D, 104,  76, 147,  93,  97,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6A,  90,  89, 125, 103, 109,
    MOVE G6D, 109,  76, 146,  93, 104,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  32,  81,  ,  ,
    WAIT

    MOVE G6A,  98,  73, 138, 106, 101,
    MOVE G6D, 102,  78, 139,  99, 101,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  33,  82,  ,  ,
    WAIT


    DELAY 200

    SPEED 8

    MOVE G6A, 105,  75, 134, 113, 102,
    MOVE G6D,  95,  80, 139, 102, 104,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  33,  82,  ,  ,
    WAIT

    MOVE G6A, 112,  73, 134, 119,  99,
    MOVE G6D,  86,  95, 113, 113, 113,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  33,  82,  ,  ,
    WAIT

    SPEED 5

    MOVE G6A, 112,  93, 114, 114,  99,
    MOVE G6D,  86,  95, 113, 109, 113,
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    GOSUB 기본자세2


    RETURN
    '**********************
gofoward_L1:
    GOSUB All_motor_mode3
    SPEED 7
    'HIGHSPEED SETON

    '오른발로 무게중심
    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    MOVE G6A,  97,  78, 147,  93, 104,
    MOVE G6D, 104,  76, 147,  93,  97,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    MOVE G6A,  95,  89, 125, 103, 104,
    MOVE G6D, 109,  76, 146,  93, 104,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  32,  81,  ,  ,
    WAIT

    MOVE G6A, 101,  81, 109, 124, 102,
    MOVE G6D, 103,  78, 146,  91, 103,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  32,  81,  ,  ,
    WAIT



    MOVE G6A, 101,  81, 133, 103, 102,
    MOVE G6D,  97,  80, 146,  89, 102,
    WAIT


    MOVE G6A, 107,  73, 140, 103, 100,
    MOVE G6D,  90,  81, 146,  85, 108,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  32,  81,  ,  ,
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    MOVE G6A, 107,  73, 140, 103, 100,
    MOVE G6D,  84,  87, 136,  92, 108,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  32,  81,  ,  ,
    WAIT



    MOVE G6A, 107,  76, 145,  91, 102,
    MOVE G6D,  87,  92, 125,  95, 109,
    MOVE G6B, 100,  30,  81,  ,  ,
    MOVE G6C, 100,  32,  81,  ,  ,
    WAIT


    MOVE G6A, 107,  76, 145,  91, 102,
    MOVE G6D,  89,  90, 125,  97, 108,
    MOVE G6B, 100,  30,  81,  ,  ,
    MOVE G6C, 100,  32,  81,  ,  ,


    SPEED 5
    GOSUB 기본자세2

    RETURN

    '******************************************
    '******************************************
후진종종걸음_골프:
    GOSUB All_motor_mode3
    넘어진확인 = 0
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  76, 145,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 후진종종걸음_골프_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  76, 145,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 후진종종걸음_골프_4
    ENDIF


    '**********************
goback_L1:
    GOSUB All_motor_mode3
    SPEED 7
    'HIGHSPEED SETON

    '오른발로 무게중심
    MOVE G6A,95,  76, 145,  93, 105
    MOVE G6D,108,  76, 145,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    '후진종종걸음_골프_1: 왼발들기
    MOVE G6D,110,  76, 147,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    '후진종종걸음_골프_3: 왼발내리고 오른발 살짝듦
    MOVE G6A, 103,  79, 147,  89, 100
    MOVE G6D,100,   65, 147, 103,  102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    '후진종종걸음_골프_3_stop:오른발들고 정자세
    MOVE G6D,95,  85, 130, 100, 104
    MOVE G6A,104,  77, 146,  93,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT

    'SPEED 15
    GOSUB 안정화자세
    'HIGHSPEED SETOFF
    SPEED 5
    GOSUB 기본자세2

    RETURN
    '**********************
goback_L2:
    GOSUB All_motor_mode3
    SPEED 5
    'HIGHSPEED SETON

    '오른발로 무게중심
    MOVE G6A,95,  76, 145,  93, 102
    MOVE G6D,106,  76, 145,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    '후진종종걸음_골프_1: 왼발들기
    MOVE G6D,111,  77, 147,  93,  102
    MOVE G6A,95,  96, 120, 95, 104
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    SPEED 4
    '후진종종걸음_골프_3: 왼발내리고 오른발 살짝듦
    MOVE G6A, 95,  92, 129,  92, 102
    MOVE G6D, 105,  85, 123, 105,  99
    WAIT

    MOVE G6A, 105,  90, 128,  97,  96,
    MOVE G6D,  95,  84, 120, 111, 106,
    WAIT



    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    MOVE G6A, 114,  90, 128,  100,  96,
    MOVE G6D,  87, 99, 105, 107, 113,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT



    SPEED 3
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    RETURN
    '**********************

후진종종걸음_골프_1:
    MOVE G6D,104,  76, 147,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6B,115
    MOVE G6C,85
    WAIT



후진종종걸음_골프_3:
    MOVE G6A, 103,  79, 147,  89, 100
    MOVE G6D,95,   65, 147, 103,  102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF
    ' 보행COUNT = 보행COUNT + 1
    ' IF 보행COUNT > 보행횟수 THEN  GOTO 후진종종걸음_골프_3_stop

    ERX 4800,A, 후진종종걸음_골프_4
    IF A <> A_old THEN
후진종종걸음_골프_3_stop:
        MOVE G6D,95,  85, 130, 100, 104
        MOVE G6A,104,  77, 146,  93,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT

        'SPEED 15
        GOSUB 안정화자세
        HIGHSPEED SETOFF
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF
    '*********************************

후진종종걸음_골프_4:
    MOVE G6A,104,  76, 147,  93,  102
    MOVE G6D,95,  95, 120, 95, 104
    MOVE G6C,115
    MOVE G6B,85
    WAIT


후진종종걸음_골프_6:
    MOVE G6D, 103,  79, 147,  89, 100
    MOVE G6A,95,   65, 147, 103,  102
    WAIT
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    'IF 보행COUNT > 보행횟수 THEN  GOTO 후진종종걸음_골프_6_stop

    ERX 4800,A, 후진종종걸음_골프_1
    IF A <> A_old THEN  'GOTO 후진종종걸음_멈춤
후진종종걸음_골프_6_stop:
        MOVE G6A,95,  85, 130, 100, 104
        MOVE G6D,104,  77, 146,  93,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT

        'SPEED 15
        GOSUB 안정화자세
        HIGHSPEED SETOFF
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    GOTO 후진종종걸음_골프_1

    '******************************************
오른쪽궤도10_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,107,  77, 147,  93, 104 , 100
    WAIT



    MOVE G6A, 111,  77, 147,  93, 104,
    MOVE G6D,  95,  90, 125, 100, 104,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT




    MOVE G6A,  90,  60, 145, 130, 110,
    MOVE G6D,  90,  60, 145, 130, 110,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6A,  69,  63, 139, 124, 115, 100
    MOVE G6D, 107,  88,  72, 161, 109, 100
    MOVE G6B, 100,  30,  80, 100, 100, 101
    MOVE G6C, 101,  31,  82, 188,  99, 100
    WAIT






    MOVE G6A,  75,  60, 145, 130, 110,
    MOVE G6D, 110,  60, 145, 125, 110,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    SPEED 9
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT


    GOTO RX_EXIT


    '******************************************
오른쪽궤도20_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,107,  77, 147,  93, 104 , 100
    WAIT



    MOVE G6A, 111,  77, 147,  93, 104,
    MOVE G6D,  95,  90, 125, 100, 104,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    MOVE G6A,  85,  60, 145, 140, 120,
    MOVE G6D,  85,  60, 145, 140, 120,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6A,  85,  60, 145, 130, 110,
    MOVE G6D, 110,  60, 145, 120, 115,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT



    SPEED 9
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT


    GOTO RX_EXIT

    '******************************************
오른쪽궤도30_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,107,  77, 147,  93, 104 , 100
    WAIT



    MOVE G6A, 111,  77, 147,  93, 104,
    MOVE G6D,  95,  90, 125, 100, 104,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    MOVE G6A, 110,  60, 145, 125, 110,
    MOVE G6D,  85,  60, 145, 130, 110,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6A,  90,  60, 145, 130, 110,
    MOVE G6D,  90,  60, 145, 130, 110,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    MOVE G6A,  80,  75, 130, 130, 110,
    MOVE G6D, 100,  50, 130, 155, 110,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT


    GOTO RX_EXIT

    '******************************************
오른쪽궤도40_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,107,  77, 147,  93, 104 , 100
    WAIT



    MOVE G6A, 111,  77, 147,  93, 104,
    MOVE G6D,  95,  90, 125, 100, 104,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT




    MOVE G6A,  90,  60, 145, 130, 110,
    MOVE G6D,  90,  60, 145, 130, 110,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    MOVE G6A,  75,  60, 145, 130, 110,
    MOVE G6D,  90,  60, 145, 125, 110,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6A,  80,  70, 130, 130, 110,
    MOVE G6D, 100,  60, 145, 125, 110,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    MOVE G6A,  80,  70, 130, 130, 110,
    MOVE G6D, 110,  60, 145, 125, 110,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    SPEED 9
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT


    GOTO RX_EXIT

    '******************************************
오른쪽궤도50_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,107,  77, 147,  93, 104 , 100
    WAIT



    MOVE G6A, 111,  77, 147,  93, 104,
    MOVE G6D,  95,  90, 125, 100, 104,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT



    SPEED 15
    MOVE G6A,  90,  60, 145, 130, 110,
    MOVE G6D,  90,  60, 145, 130, 110,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6A,  75,  60, 145, 130, 110,
    MOVE G6D, 120,  60, 145, 125, 110,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT



    SPEED 9
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT


    GOTO RX_EXIT

    '******************************************
오른쪽궤도60_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,107,  77, 147,  93, 104 , 100
    WAIT



    MOVE G6A, 111,  77, 147,  93, 104,
    MOVE G6D,  95,  90, 125, 100, 104,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT




    MOVE G6A,  90,  60, 145, 130, 110,
    MOVE G6D,  90,  60, 145, 130, 110,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    MOVE G6A,  69,  63, 139, 124, 115,
    MOVE G6D, 107, 103,  72, 161, 109,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 101,  31,  82,  ,  ,
    WAIT




    MOVE G6A,  75,  60, 145, 130, 110,
    MOVE G6D, 110,  60, 145, 125, 110,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    SPEED 9
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT


    GOTO RX_EXIT

    '******************************************
오른쪽궤도70_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,107,  77, 147,  93, 104 , 100
    WAIT



    MOVE G6A, 111,  77, 147,  93, 104,
    MOVE G6D,  95,  90, 125, 100, 104,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT




    MOVE G6A,  80,  75, 130, 130, 110,
    MOVE G6D, 100,  50, 130, 155, 110,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    SPEED 9
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOTO RX_EXIT

    '******************************************
오른쪽궤도80_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,107,  77, 147,  93, 104 , 100
    WAIT



    MOVE G6A, 111,  77, 147,  93, 104,
    MOVE G6D,  95,  90, 125, 100, 104,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    MOVE G6A,  80,  75, 130, 130, 110,
    MOVE G6D, 100,  50, 130, 155, 110,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT



    MOVE G6A,  68,  87, 125, 118, 110,
    MOVE G6D, 107, 112,  56, 161, 115,
    MOVE G6B, 101,  30,  80,  ,  ,
    MOVE G6C, 101,  32,  81,  ,  ,
    WAIT


    MOVE G6A,  71,  87, 125, 116, 109, 100
    MOVE G6D, 104,  98,  81, 144, 112, 100
    MOVE G6B, 102,  30,  80, 100, 100, 100
    MOVE G6C, 102,  34,  82, 188, 100, 100
    WAIT




    MOVE G6A,  75,  60, 145, 130, 110,
    MOVE G6D, 110,  60, 145, 125, 110,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    SPEED 9
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOTO RX_EXIT

    '******************************************
오른쪽궤도90_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,107,  77, 147,  93, 104 , 100
    WAIT



    MOVE G6A, 111,  77, 147,  93, 104,
    MOVE G6D,  95,  90, 125, 100, 104,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    MOVE G6A,  80,  75, 130, 130, 110,
    MOVE G6D, 100,  50, 130, 155, 110,
    MOVE G6B, 125,  50,  80,  ,  ,
    MOVE G6C, 125,  50,  80,  ,  ,
    WAIT



    MOVE G6A,  68,  87, 125, 118, 110,
    MOVE G6D, 107, 112,  56, 161, 115,
    MOVE G6B, 125,  50,  80,  ,  ,
    MOVE G6C, 125,  50,  80,  ,  ,
    WAIT

    MOVE G6A,  71,  87, 125, 116, 109,
    MOVE G6D, 104,  98,  81, 144, 112,
    MOVE G6B, 102,  35,  80,  ,  ,
    MOVE G6C, 132,  39,  82,  ,  ,
    WAIT


    MOVE G6A,  75,  55, 145, 130, 110,
    MOVE G6D, 110,  60, 145, 125, 110,
    MOVE G6B,  95,  35,  80,  ,  ,
    MOVE G6C, 135,  35,  80,  ,  ,
    WAIT



    SPEED 9
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOTO RX_EXIT

    '******************************************
오른쪽궤도100_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,107,  77, 147,  93, 104 , 100
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6A, 111,  77, 147,  93, 104,
    MOVE G6D,  95,  90, 125, 100, 104,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    SPEED 20
    MOVE G6A,  80,  75, 130, 130, 110,
    MOVE G6D, 100,  60, 120, 155, 110,
    MOVE G6B,  50,  40,  80,  ,  ,
    MOVE G6C, 160,  40,  80,  ,  ,
    WAIT


    MOVE G6A,  63,  87, 125, 118, 110,
    MOVE G6D, 107, 112,  56, 161, 115,
    MOVE G6B,  65,  40,  80,  ,  ,
    MOVE G6C, 160,  40,  80,  ,  ,
    WAIT


    MOVE G6A,  71,  87, 125, 116, 109,
    MOVE G6D, 104,  98,  81, 144, 112,
    MOVE G6B,  65,  40,  80,  ,  ,
    MOVE G6C, 140,  40,  80,  ,  ,
    WAIT

    SPEED 12
    MOVE G6A,  75,  55, 145, 130, 110,
    MOVE G6D, 110,  60, 145, 125, 110,
    MOVE G6B,  95,  40,  80,  ,  ,
    MOVE G6C, 130,  40,  80,  ,  ,
    WAIT



    SPEED 9
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOTO RX_EXIT

    '******************************************
CCW_걸음:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6A, 95,  90, 125, 100, 104, 100
    MOVE G6D,107,  77, 147,  93, 104 , 100
    MOVE G6C,100,  30,  80, 190
    WAIT



    MOVE G6D, 111,  77, 147,  93, 104,
    MOVE G6A,  95,  90, 125, 100, 104,
    MOVE G6C, 100,  30,  80,  190,  ,
    MOVE G6B, 100,  30,  80,  ,  ,
    WAIT




    MOVE G6D,  90,  60, 145, 130, 110,
    MOVE G6A,  90,  60, 145, 130, 110,
    MOVE G6C, 100,  30,  80,  190,  ,
    MOVE G6B, 100,  30,  80,  ,  ,
    WAIT


    MOVE G6D,  69,  63, 139, 124, 115,
    MOVE G6A, 107, 103,  72, 161, 109,
    MOVE G6C, 100,  30,  80,  190,  ,
    MOVE G6B, 101,  31,  82,  ,  ,
    WAIT




    MOVE G6D,  75,  60, 145, 130, 110,
    MOVE G6A, 110,  60, 145, 125, 110,
    MOVE G6C, 100,  30,  80,  190,  ,
    MOVE G6B, 100,  30,  80,  ,  ,
    WAIT


    SPEED 9
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  30,  80, 190
    MOVE G6B,100,  30,  80,
    WAIT


    GOTO RX_EXIT

    '******************************************
CW_걸음:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,107,  77, 147,  93, 104 , 100
    WAIT



    MOVE G6A, 111,  77, 147,  93, 104,
    MOVE G6D,  95,  90, 125, 100, 104,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT




    MOVE G6A,  90,  60, 145, 130, 110,
    MOVE G6D,  90,  60, 145, 130, 110,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    MOVE G6A,  69,  63, 139, 124, 115,
    MOVE G6D, 107, 103,  72, 161, 109,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 101,  31,  82,  ,  ,
    WAIT




    MOVE G6A,  75,  60, 145, 130, 110,
    MOVE G6D, 110,  60, 145, 125, 110,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    SPEED 9
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT


    GOTO RX_EXIT

    '******************************************

CCW_회전3:
    GOSUB All_motor_mode3

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 8

    MOVE G6A,  97,  74, 145, 100, 103,
    MOVE G6D, 103,  79, 135, 104, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6A,  86,  79, 141,  97, 111,
    MOVE G6D, 110,  76, 146,  93,  99,
    MOVE G6B, 110,  40,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  ,  ,
    WAIT

    MOVE G6A,  71,  64, 141, 122, 126,
    MOVE G6D, 110,  76, 131, 118,  99,
    MOVE G6B, 120,  50,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  ,  ,
    WAIT

    MOVE G6A,  66,  64, 141, 122, 131,
    MOVE G6D, 105,  76, 131, 118,  99,
    MOVE G6B, 120,  50,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  ,  ,
    WAIT


    MOVE G6A,  90,  60, 125, 155, 120,
    MOVE G6D,  84,  84, 130, 120, 110,
    MOVE G6B, 120,  50,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  ,  ,
    WAIT


    DELAY 200

    MOVE G6A,  90,  60, 125, 145, 120,
    MOVE G6D,  84,  79, 130, 110, 110,
    MOVE G6B, 120,  50,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  ,  ,
    WAIT



    SPEED 8
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  30,  80,
    MOVE G6B,100,  30,  80, 190
    WAIT

    GOTO RX_EXIT
    '******************************************
CCW_회전4:
    GOSUB All_motor_mode3
    'GOSUB 자이로OFF

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 8

    MOVE G6A,  97,  74, 145, 100, 103,
    MOVE G6D, 103,  79, 135, 104, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6A,  86,  79, 141,  97, 111,
    MOVE G6D, 110,  76, 146,  93,  99,
    MOVE G6B, 110,  40,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  ,  ,
    WAIT
    '
    MOVE G6A,  71,  64, 141, 122, 126,
    MOVE G6D, 110,  76, 131, 118,  99,
    MOVE G6B, 120,  50,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  ,  ,
    WAIT
    '
    MOVE G6A,  66,  64, 141, 122, 131,
    MOVE G6D, 105,  76, 131, 118,  99,
    MOVE G6B, 120,  50,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  ,  ,
    WAIT


    MOVE G6A,  90,  60, 125, 155, 120,
    MOVE G6D,  84,  84, 130, 120, 110,
    MOVE G6B, 120,  50,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  ,  ,
    WAIT


    DELAY 200


    MOVE G6A,  90,  60, 125, 145, 120,
    MOVE G6D,  84,  89, 130, 110, 110,
    MOVE G6B, 120,  50,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  ,  ,
    WAIT


    SPEED 8
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  30,  80,
    MOVE G6B,100,  30,  80, 190
    WAIT

    'GOSUB 자이로ON

    GOTO RX_EXIT
    '******************************************
CCW_회전5:
    GOSUB All_motor_mode3

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 8

    MOVE G6A,  97,  74, 145, 100, 103,
    MOVE G6D, 103,  79, 135, 104, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6A,  86,  79, 141,  97, 111,
    MOVE G6D, 110,  76, 146,  93,  99,
    MOVE G6B, 110,  40,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  ,  ,
    WAIT
    '
    MOVE G6A,  71,  64, 141, 122, 126,
    MOVE G6D, 110,  76, 131, 118,  99,
    MOVE G6B, 120,  50,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  ,  ,
    WAIT
    '
    MOVE G6A,  66,  64, 141, 122, 131,
    MOVE G6D, 105,  76, 131, 118,  99,
    MOVE G6B, 120,  50,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  ,  ,
    WAIT


    MOVE G6A,  90,  60, 125, 155, 120,
    MOVE G6D,  84,  84, 130, 120, 110,
    MOVE G6B, 120,  50,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  ,  ,
    WAIT


    DELAY 200

    MOVE G6A,  90,  60, 125, 145, 120,
    MOVE G6D,  84,  89, 130, 110, 110,
    MOVE G6B, 120,  50,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  ,  ,
    WAIT


    SPEED 10
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  30,  80,
    MOVE G6B,100,  30,  80, 190
    WAIT

    GOTO RX_EXIT
    '******************************************
CW_회전5:
    GOSUB All_motor_mode3

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 8

    MOVE G6D,  97,  74, 145, 100, 103,
    MOVE G6A, 103,  79, 135, 104, 100,
    MOVE G6C, 100,  30,  80,  ,  ,
    MOVE G6B, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6D,  86,  79, 141,  97, 111,
    MOVE G6A, 110,  76, 146,  93,  99,
    MOVE G6C, 110,  40,  81,  ,  ,
    MOVE G6B,  95,  32,  81,  ,  ,
    WAIT
    '
    MOVE G6D,  71,  64, 141, 122, 126,
    MOVE G6A, 110,  76, 131, 118,  99,
    MOVE G6C, 120,  50,  81,  ,  ,
    MOVE G6B,  95,  32,  81,  ,  ,
    WAIT
    '
    MOVE G6D,  66,  64, 141, 122, 131,
    MOVE G6A, 105,  76, 131, 118,  99,
    MOVE G6C, 120,  50,  81,  ,  ,
    MOVE G6B,  95,  32,  81,  ,  ,
    WAIT


    MOVE G6D,  90,  60, 125, 155, 120,
    MOVE G6A,  84,  84, 130, 120, 110,
    MOVE G6C, 120,  50,  81,  ,  ,
    MOVE G6B,  95,  32,  81,  ,  ,
    WAIT


    DELAY 200

    MOVE G6D,  90,  60, 125, 145, 120,
    MOVE G6A,  84,  89, 130, 110, 110,
    MOVE G6C, 120,  50,  81,  ,  ,
    MOVE G6B,  95,  32,  81,  ,  ,
    WAIT


    SPEED 10
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  30,  80,
    MOVE G6B,100,  30,  80, 190
    WAIT

    GOTO RX_EXIT
    '******************************************
CCW_회전6:
    GOSUB All_motor_mode3

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 8

    MOVE G6A,  97,  74, 145, 100, 103,
    MOVE G6D, 103,  79, 135, 104, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  190,  ,
    WAIT

    MOVE G6A,  86,  79, 141,  97, 111,
    MOVE G6D, 110,  76, 146,  93,  99,
    MOVE G6B, 110,  40,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  190,  ,
    WAIT
    '
    MOVE G6A,  71,  64, 141, 122, 126,
    MOVE G6D, 110,  76, 131, 118,  99,
    MOVE G6B, 120,  50,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  190,  ,
    WAIT
    '
    MOVE G6A,  66,  64, 141, 122, 131,
    MOVE G6D, 105,  76, 131, 118,  99,
    MOVE G6B, 120,  50,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  190,  ,
    WAIT


    MOVE G6A,  90,  60, 125, 155, 120,
    MOVE G6D,  84,  84, 130, 120, 110,
    MOVE G6B, 120,  50,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  190,  ,
    WAIT


    DELAY 200

    MOVE G6A,  90,  60, 125, 145, 120,
    MOVE G6D,  84,  94, 130, 110, 110,
    MOVE G6B, 120,  50,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  190,  ,
    WAIT


    SPEED 8
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  30,  80,
    MOVE G6B,100,  30,  80, 190
    WAIT

    GOTO RX_EXIT
    '******************************************
CCW_회전7:
    GOSUB All_motor_mode3

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 8

    MOVE G6A,  97,  74, 145, 100, 103,
    MOVE G6D, 103,  79, 135, 104, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6A,  89,  72, 141,  102, 111,
    MOVE G6D, 110,  76, 146,  96,  99,
    MOVE G6B, 110,  40,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  ,  ,
    WAIT
    '
    MOVE G6A,  79,  60, 141, 122, 120,
    MOVE G6D, 113,  76, 131, 116,  99,
    MOVE G6B, 120,  50,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  ,  ,
    WAIT

    MOVE G6A,  99,  74,  94, 162, 108, 100
    MOVE G6D,  80,  100, 107, 128, 117, 100
    MOVE G6B, 122,  50,  81, 100, 100, 101
    MOVE G6C,  97,  35,  82, 185,  98, 100
    WAIT

    DELAY 200


    MOVE G6A,  99,  67, 104, 153, 110, 100
    MOVE G6D,  80,  97, 112, 116, 121, 100
    MOVE G6B, 124,  46,  80, 100, 100, 101
    MOVE G6C,  98,  39,  83, 184,  98, 100
    WAIT




    SPEED 12
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  30,  80,
    MOVE G6B,100,  30,  80, 190
    WAIT

    GOTO RX_EXIT
    '******************************************
CW_회전7:
    GOSUB All_motor_mode3

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 8

    MOVE G6D,  97,  74, 145, 100, 103,
    MOVE G6A, 103,  79, 135, 104, 100,
    MOVE G6C, 100,  30,  80,  ,  ,
    MOVE G6B, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6D,  89,  72, 141,  102, 111,
    MOVE G6A, 110,  76, 146,  96,  99,
    MOVE G6C, 110,  40,  81,  ,  ,
    MOVE G6B,  95,  32,  81,  ,  ,
    WAIT
    '
    MOVE G6D,  79,  60, 141, 122, 120,
    MOVE G6A, 113,  76, 131, 116,  99,
    MOVE G6C, 120,  50,  81,  ,  ,
    MOVE G6B,  95,  32,  81,  ,  ,
    WAIT

    MOVE G6A,  87, 110,  92, 123, 112, 100
    MOVE G6D,  93,  85,  86, 152, 112, 100
    MOVE G6B,  98,  35,  82, 100, 100, 101
    MOVE G6C, 122,  43,  81, 185,  99, 100
    WAIT





    DELAY 200

    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOTO RX_EXIT
    '******************************************
CCW_회전8:
    GOSUB All_motor_mode3

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 8

    MOVE G6A,  97,  74, 145, 100, 103,
    MOVE G6D, 103,  79, 135, 104, 100,
    MOVE G6C, 100,  30,  80,  ,  ,
    MOVE G6B, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6A,  89,  72, 141,  102, 111,
    MOVE G6D, 110,  76, 146,  96,  99,
    MOVE G6B, 110,  40,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  ,  ,
    WAIT
    '
    MOVE G6A,  79,  60, 141, 122, 120,
    MOVE G6D, 113,  76, 131, 116,  99,
    MOVE G6B, 120,  50,  81,  ,  ,
    MOVE G6C,  95,  32,  81,  ,  ,
    WAIT

    MOVE G6D,  87, 110,  92, 123, 112, 100
    MOVE G6A,  93,  85,  86, 152, 112, 100
    MOVE G6C,  98,  35,  82, , ,
    MOVE G6B, 122,  43,  81, 185,  99, 100
    WAIT





    DELAY 200

    SPEED 12
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  30,  80,
    MOVE G6B,100,  30,  80, 190
    WAIT

    GOTO RX_EXIT


    '******************************************
CW_회전3:
    GOSUB All_motor_mode3

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 8

    MOVE G6D,  97,  74, 145, 100, 103,
    MOVE G6A, 103,  79, 135, 104, 100,
    MOVE G6C, 100,  30,  80,  ,  ,
    MOVE G6B, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6D,  86,  79, 141,  97, 111,
    MOVE G6A, 110,  76, 146,  93,  99,
    MOVE G6C, 110,  40,  81,  ,  ,
    MOVE G6B,  95,  32,  81,  ,  ,
    WAIT

    MOVE G6D,  71,  64, 141, 122, 126,
    MOVE G6A, 110,  76, 131, 118,  99,
    MOVE G6C, 120,  50,  81,  ,  ,
    MOVE G6B,  95,  32,  81,  ,  ,
    WAIT

    MOVE G6D,  66,  64, 141, 122, 131,
    MOVE G6A, 105,  76, 131, 118,  99,
    MOVE G6C, 120,  50,  81,  ,  ,
    MOVE G6B,  95,  32,  81,  ,  ,
    WAIT


    MOVE G6D,  90,  60, 125, 155, 120,
    MOVE G6A,  84,  84, 130, 120, 110,
    MOVE G6C, 120,  50,  81,  ,  ,
    MOVE G6B,  95,  32,  81,  ,  ,
    WAIT


    DELAY 200

    MOVE G6D,  90,  60, 125, 145, 120,
    MOVE G6A,  84,  79, 130, 110, 110,
    MOVE G6C, 120,  50,  81,  ,  ,
    MOVE G6B,  95,  32,  81,  ,  ,
    WAIT



    SPEED 8
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  30,  80,
    MOVE G6B,100,  30,  80, 190
    WAIT

    GOTO RX_EXIT


    '******************************************
세레모니:
    PRINT "VOLUME 200 !"
    PRINT "SOUND 44 !" '안녕하세요

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,107,  77, 147,  93, 104 , 100
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6A, 111,  77, 147,  93, 104,
    MOVE G6D,  95,  90, 125, 100, 104,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    SPEED 20
    MOVE G6A,  80,  75, 130, 130, 110,
    MOVE G6D, 100,  60, 120, 155, 110,
    MOVE G6B,  50,  40,  80,  ,  ,
    MOVE G6C, 160,  40,  80,  ,  ,
    WAIT

    MOVE G6A,  71,  87, 125, 116, 109,
    MOVE G6D, 104,  98,  81, 144, 112,
    MOVE G6B,  15,  50,  80,  ,  ,
    MOVE G6C, 180,  30,  30,  ,  ,
    WAIT


    GOTO RX_EXIT



    '******************************************
오른쪽옆으로10_골프: '원래의도는 2 cm
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,107,  77, 147,  93, 104 , 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 147, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 103, 100
    WAIT

    SPEED 12
    MOVE G6D,95,  76, 147,  93, 98, 100
    MOVE G6A,95,  76, 147,  93, 98, 100
    WAIT

    SPEED 3
    GOSUB 기본자세2

    GOTO RX_EXIT

    '************************************************
오른쪽옆으로20_골프: '오른쪽옆으로 3.5cm~3.8cm이동
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 107, 100
    MOVE G6A,107,  77, 147,  93, 107 , 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 147, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 12
    MOVE G6D,95,  76, 147,  93, 98, 100
    MOVE G6A,95,  76, 147,  93, 98, 100
    WAIT

    SPEED 3
    GOSUB 기본자세2

    GOTO RX_EXIT
    '************************************************

왼쪽옆으로20_골프: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6A, 95,  90, 125, 100, 104, 100
    MOVE G6D,105,  76, 146,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  76, 146, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 12
    MOVE G6A,95,  76, 146,  93, 98, 100
    MOVE G6D,95,  76, 146,  93, 98, 100
    WAIT

    SPEED 3
    GOSUB 기본자세2

    GOTO RX_EXIT

    '**********************************************
왼쪽옆으로10_골프: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    GOSUB Leg_motor_mode3

    SPEED 12
    MOVE G6A, 95,  90, 125, 100, 103, 100
    MOVE G6D,105,  76, 146,  93, 103, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  76, 146, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,95,  76, 146,  93, 98, 100
    MOVE G6D,95,  76, 146,  93, 98, 100
    WAIT

    SPEED 3
    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************
왼쪽옆으로10_골프_2: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 8
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,105,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190

    SPEED 5
    MOVE G6A, 89,  90, 125, 100, 103, 100
    MOVE G6D,110,  76, 145,  93, 103, 100
    WAIT

    SPEED 5
    MOVE G6A, 97,  76, 145, 93, 103, 100
    MOVE G6D,97,  76, 145,  93, 103, 100
    WAIT
    DELAY 20

    MOVE G6A, 103,  79, 140,  93,  96, 100
    MOVE G6D,  92,  76, 144,  92, 113, 100
    WAIT
    DELAY 20

    MOVE G6A, 114,  82, 140,  93,  96, 100
    MOVE G6D,  88,  82, 130,  96, 113, 100
    WAIT

    SPEED 3
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT

    mode = 0

    GOTO RX_EXIT
    '**********************************************
오른쪽옆으로10_골프_2: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 8
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,105,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190

    SPEED 5
    MOVE G6D, 89,  90, 125, 100, 103, 100
    MOVE G6A,110,  76, 145,  93, 103, 100
    WAIT

    SPEED 3
    MOVE G6D, 97,  76, 145, 93, 103, 100
    MOVE G6A,97,  76, 145,  93, 103, 100
    WAIT
    DELAY 20

    MOVE G6D, 103,  79, 140,  93,  96, 100
    MOVE G6A,  92,  76, 144,  92, 113, 100
    WAIT

    MOVE G6D, 114,  82, 140,  93,  96, 100
    MOVE G6A,  88,  82, 130,  96, 113, 100
    WAIT

    SPEED 3
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    WAIT

    mode = 0

    GOTO RX_EXIT
    '******************************************
오른쪽옆으로70연속_골프:
    MOTORMODE G6A,3,3,2,3,2
    MOTORMODE G6D,3,3,2,3,2

오른쪽옆으로70연속_골프_loop:
    DELAY  10

    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,103,  77, 147,  93, 107, 100
    WAIT

    SPEED 13
    MOVE G6D, 102,  77, 147, 93, 100, 100
    MOVE G6A,83,  77, 140,  96, 115, 100
    WAIT

    SPEED 13
    MOVE G6D,98,  77, 147,  93, 100, 100
    MOVE G6A,98,  77, 147,  93, 100, 100
    WAIT

    SPEED 12
    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    WAIT


    SPEED 3
    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************

왼쪽옆으로70연속_골프:
    MOTORMODE G6A,3,3,2,3,2
    MOTORMODE G6D,3,3,2,3,2
왼쪽옆으로70연속_골프_loop:
    DELAY  10

    SPEED 10
    MOVE G6A, 90,  90, 120, 95, 110, 100	
    MOVE G6D,100,  76, 146,  93, 107, 100	
    WAIT

    SPEED 13
    MOVE G6A, 102,  76, 146, 93, 100, 100
    MOVE G6D,83,  79, 140,  99, 115, 100
    WAIT

    SPEED 13
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6D,98,  76, 146,  93, 100, 100
    WAIT

    SPEED 12
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    WAIT


    SPEED 3
    GOSUB 기본자세2

    GOTO RX_EXIT

    '**********************************************
    '************************************************
    '*********************************************

왼쪽턴3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
왼쪽턴3_LOOP:

    IF 보행순서 = 0 THEN
        보행순서 = 1
        SPEED 15
        MOVE G6D,100,  73, 145,  93, 100, 100
        MOVE G6A,100,  79, 145,  93, 100, 100
        WAIT

        SPEED 6
        MOVE G6D,100,  84, 145,  78, 100, 100
        MOVE G6A,100,  68, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6D,90,  90, 145,  78, 102, 100
        MOVE G6A,104,  71, 145,  105, 100, 100
        WAIT
        SPEED 7
        MOVE G6D,90,  80, 130, 102, 104
        MOVE G6A,105,  76, 146,  93,  100
        WAIT



    ELSE
        보행순서 = 0
        SPEED 15
        MOVE G6D,100,  73, 145,  93, 100, 100
        MOVE G6A,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6D,100,  88, 145,  78, 100, 100
        MOVE G6A,100,  65, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6D,104,  86, 146,  80, 100, 100
        MOVE G6A,90,  58, 145,  110, 100, 100
        WAIT

        SPEED 7
        MOVE G6A,90,  85, 130, 98, 104
        MOVE G6D,105,  77, 146,  93,  100
        WAIT



    ENDIF

    SPEED 12
    GOSUB 기본자세2


    GOTO RX_EXIT

    '**********************************************
오른쪽턴3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

오른쪽턴3_LOOP:

    IF 보행순서 = 0 THEN
        보행순서 = 1
        SPEED 15
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6A,100,  84, 145,  78, 100, 100
        MOVE G6D,100,  68, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6A,90,  90, 145,  78, 102, 100
        MOVE G6D,104,  71, 145,  105, 100, 100
        WAIT
        SPEED 7
        MOVE G6A,90,  80, 130, 102, 104
        MOVE G6D,105,  76, 146,  93,  100
        WAIT



    ELSE
        보행순서 = 0
        SPEED 15
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6A,100,  88, 145,  78, 100, 100
        MOVE G6D,100,  65, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6A,104,  86, 146,  80, 100, 100
        MOVE G6D,90,  58, 145,  110, 100, 100
        WAIT

        SPEED 7
        MOVE G6D,90,  85, 130, 98, 104
        MOVE G6A,105,  77, 146,  93,  100
        WAIT

    ENDIF
    SPEED 12
    GOSUB 기본자세2

    GOTO RX_EXIT

    '******************************************************
    '**********************************************
왼쪽턴5_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 5
    MOVE G6A,100,  81, 145,  88, 106, 100
    MOVE G6D,94,  71, 145, 98, 100, 100
    WAIT

    SPEED 12
    MOVE G6A,97,  81, 145,  88, 104, 100
    MOVE G6D,91,  71, 145, 98, 96, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB 기본자세2
    GOTO RX_EXIT
    '**********************************************
오른쪽턴5_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 5
    MOVE G6A,97,  71, 145,  98, 103, 100
    MOVE G6D,97,  81, 145,  88, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  71, 145,  98, 101, 100
    MOVE G6D,94,  81, 145,  88, 101, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************

    '**********************************************
왼쪽턴10_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 5
    MOVE G6A,100,  86, 145,  83, 106, 100
    MOVE G6D,94,  66, 145, 103, 100, 100
    WAIT

    SPEED 12
    MOVE G6A,97,  86, 145,  83, 104, 100
    MOVE G6D,91,  66, 145, 103, 96, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB 기본자세2
    GOTO RX_EXIT
    '**********************************************
오른쪽턴10_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 5
    MOVE G6A,97,  66, 145,  103, 103, 100
    MOVE G6D,97,  86, 145,  83, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  66, 145,  103, 101, 100
    MOVE G6D,94,  86, 145,  83, 101, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************
    '**********************************************
왼쪽턴20_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 8
    MOVE G6A,95,  96, 145,  73, 108, 100
    MOVE G6D,91,  56, 145,  113, 102, 100
    WAIT

    SPEED 12
    MOVE G6A,91,  96, 145,  73, 108, 100
    MOVE G6D,88,  56, 145,  113, 102, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************
오른쪽턴20_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 8
    MOVE G6A,95,  56, 145,  113, 105, 100
    MOVE G6D,95,  96, 145,  73, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  56, 145,  113, 105, 100
    MOVE G6D,93,  96, 145,  73, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100

    WAIT

    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************

    '**********************************************	


    '**********************************************
왼쪽턴45_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


    SPEED 10
    MOVE G6A,95,  106, 145,  63, 108, 100
    MOVE G6D,91,  46, 145,  123, 102, 100
    WAIT

    SPEED 12
    MOVE G6A,91,  106, 145,  63, 108, 100
    MOVE G6D,88,  46, 145,  123, 102, 100
    WAIT

    SPEED 8
    GOSUB 기본자세2

    '
    GOTO RX_EXIT

    '**********************************************
오른쪽턴45_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


    SPEED 10
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 8
    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************
왼쪽턴60_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


    SPEED 15
    MOVE G6A,95,  116, 145,  53, 108, 100
    MOVE G6D,91,  36, 145,  133, 102, 100
    WAIT

    SPEED 15
    MOVE G6A,91,  116, 145,  53, 108, 100
    MOVE G6D,88,  36, 145,  133, 102, 100
    WAIT

    SPEED 10
    GOSUB 기본자세2

    GOTO RX_EXIT

    '**********************************************
오른쪽턴60_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


    SPEED 15
    MOVE G6A,95,  36, 145,  133, 105, 100
    MOVE G6D,95,  116, 145,  53, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  36, 145,  133, 105, 100
    MOVE G6D,90,  116, 145,  53, 105, 100
    WAIT

    SPEED 10
    GOSUB 기본자세2

    GOTO RX_EXIT
    '****************************************

뒤로일어나기:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON		

    GOSUB 자이로OFF

    GOSUB All_motor_Reset

    SPEED 15
    GOSUB 기본자세

    MOVE G6A,90, 130, 120,  80, 110, 100
    MOVE G6D,90, 130, 120,  80, 110, 100
    MOVE G6B,150, 160,  10, 100, 100, 100
    MOVE G6C,150, 160,  10, 190, 100, 100
    WAIT

    MOVE G6B,185, 160,  10, 100, 100, 100
    MOVE G6C,185, 160,  10, 190, 100, 100
    WAIT

    SPEED 12
    MOVE G6B,185,  50, 10,  100, 100, 100
    MOVE G6C,185,  50, 10,  190, 100, 100
    WAIT



    SPEED 10
    MOVE G6A, 80, 155,  80, 150, 150, 100
    MOVE G6D, 80, 155,  80, 150, 150, 100
    MOVE G6B,185,  20, 50,  100, 100, 100
    MOVE G6C,185,  20, 50,  190, 100, 100
    WAIT

    MOVE G6A, 75, 162,  55, 162, 155, 100
    MOVE G6D, 75, 162,  55, 162, 155, 100
    MOVE G6B,188,  10, 100, 100, 100, 100
    MOVE G6C,188,  10, 100, 190, 100, 100
    WAIT

    SPEED 10
    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,170,  10, 100, 100, 100, 100
    MOVE G6C,170,  10, 100, 190, 100, 100
    WAIT

    DELAY 200


    GOSUB Leg_motor_mode3	
    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 190, 100, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 190, 100, 100
    WAIT
    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT
    SPEED 10
    GOSUB 기본자세3

    넘어진확인 = 1

    DELAY 200
    GOSUB 자이로ON
    GOTO RX_EXIT


    RETURN


    '**********************************************
앞으로일어나기:


    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB 자이로OFF

    HIGHSPEED SETOFF

    GOSUB All_motor_Reset

    SPEED 15
    MOVE G6A,100, 35,  70, 130, 100,
    MOVE G6D,100, 35,  70, 130, 100,
    MOVE G6B,15,  140,  15
    MOVE G6C,15,  140,  15
    WAIT

    SPEED 12
    MOVE G6B,15,  100,  10
    MOVE G6C,15,  100,  10
    WAIT

    SPEED 12
    MOVE G6A,100, 136,  35, 80, 100,
    MOVE G6D,100, 136,  35, 80, 100,
    MOVE G6B,15,  15,  75
    MOVE G6C,15,  15,  75
    WAIT

    MOVE G6A, 100, 165,  60,  20, 100,
    MOVE G6D, 100, 165,  60,  20, 100,
    MOVE G6B,  30,  20,  95,  ,  ,
    MOVE G6C,  30,  20,  95,  ,  ,
    WAIT


    SPEED 10
    MOVE G6A,100, 165,  75, 20, 100,
    MOVE G6D,100, 165,  75, 20, 100,
    MOVE G6B,15,  20,  95
    MOVE G6C,15,  20,  95
    WAIT

    DELAY 200

    GOSUB Leg_motor_mode3

    SPEED 8
    MOVE G6A,100, 165,  85, 20, 100,
    MOVE G6D,100, 165,  85, 20, 100,
    MOVE G6B,130,  50,  60
    MOVE G6C,130,  50,  60
    WAIT

    SPEED 8
    MOVE G6A,100, 165,  85, 30, 100,
    MOVE G6D,100, 165,  85, 30, 100,
    WAIT

    SPEED 8
    MOVE G6A,100, 155,  45, 110, 100,
    MOVE G6D,100, 155,  45, 110, 100,
    MOVE G6B,130,  50,  60
    MOVE G6C,130,  50,  60
    WAIT

    SPEED 6
    MOVE G6A,100, 145,  45, 130, 100,
    MOVE G6D,100, 145,  45, 130, 100,
    WAIT


    SPEED 8
    GOSUB All_motor_mode2
    GOSUB 기본자세3
    넘어진확인 = 1
    '******************************
    DELAY 200
    GOSUB 자이로ON
    GOSUB GOSUB_RX_EXIT

    RETURN

    '******************************************

머리왼쪽30도:
    SPEED 머리이동속도
    SERVO 11,70
    GOTO RX_EXIT

머리왼쪽45도:
    SPEED 머리이동속도
    SERVO 11,55
    GOTO RX_EXIT

머리왼쪽60도:
    SPEED 머리이동속도
    SERVO 11,40
    GOTO RX_EXIT

머리왼쪽90도:
    SPEED 머리이동속도
    SERVO 11,10
    GOTO RX_EXIT

머리오른쪽30도:
    SPEED 머리이동속도
    SERVO 11,130
    GOTO RX_EXIT

머리오른쪽45도:
    SPEED 머리이동속도
    SERVO 11,145
    GOTO RX_EXIT	

머리오른쪽60도:
    SPEED 머리이동속도
    SERVO 11,160
    GOTO RX_EXIT

머리오른쪽90도:
    SPEED 머리이동속도
    SERVO 11,190
    GOTO RX_EXIT

머리좌우중앙:
    SPEED 머리이동속도
    SERVO 11,100
    GOTO RX_EXIT

머리상하정면:
    SPEED 머리이동속도
    SERVO 11,100	
    SPEED 5
    GOSUB 기본자세
    GOTO RX_EXIT

전방상향100도:
    SPEED 3
    S11 = MOTORIN(11)
    S16 = MOTORIN(16)
    S16 = S16 - 5
    SERVO 11, S11
    SERVO 16, S16	

    ETX 4800,23
    GOTO RX_EXIT
    '******************************************

정지동작고개100:
    SPEED 7

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    SERVO 11, 100
    SERVO 16, 100
    WAIT
    mode = 0

    RETURN

    ETX 4800,34
    GOTO RX_EXIT
    '******************************************
전방하향80도:

    SPEED 3
    SERVO 16, 80
    SERVO 11, 100
    ETX 4800,35
    GOTO RX_EXIT
    '******************************************
전방하향60도:

    SPEED 3
    SERVO 16, 65
    SERVO 11, 100
    ETX 4800,36
    GOTO RX_EXIT
    '******************************************
전방35도:

    SPEED 3
    SERVO 16, 35
    SERVO 11, 100
    ETX 4800,40
    GOTO RX_EXIT
    '******************************************
전방40도:

    SPEED 3
    SERVO 16, 40
    SERVO 11, 100
    ETX 4800,41
    GOTO RX_EXIT
    '******************************************
전방45도:

    SPEED 3
    SERVO 16, 45
    SERVO 11, 100
    ETX 4800,42
    GOTO RX_EXIT
    '******************************************
전방50도:

    SPEED 3
    SERVO 16, 50
    SERVO 11, 100
    ETX 4800,43
    GOTO RX_EXIT
    '******************************************
전방55도:

    SPEED 3
    SERVO 16, 55
    SERVO 11, 100
    ETX 4800,44
    GOTO RX_EXIT
    '******************************************
전방60도:

    SPEED 3
    SERVO 16, 60
    SERVO 11, 100
    ETX 4800,45
    GOTO RX_EXIT
    '******************************************
전방65도:

    SPEED 3
    SERVO 16, 65
    SERVO 11, 100
    ETX 4800,46
    GOTO RX_EXIT
    '******************************************
전방70도:

    SPEED 3
    SERVO 16, 70
    SERVO 11, 100
    ETX 4800,47
    GOTO RX_EXIT
    '******************************************
전방75도:

    SPEED 3
    SERVO 16, 75
    SERVO 11, 100
    ETX 4800,48
    GOTO RX_EXIT
    '******************************************
전방80도:

    SPEED 3
    SERVO 16, 80
    SERVO 11, 100
    ETX 4800,49
    GOTO RX_EXIT

    '******************************************
전방85도:

    SPEED 3
    SERVO 16, 85
    SERVO 11, 100
    ETX 4800,50
    GOTO RX_EXIT
    '******************************************
전방90도:

    SPEED 3
    SERVO 16, 90
    SERVO 11, 100
    ETX 4800,51
    GOTO RX_EXIT
    '******************************************
전방95도:

    SPEED 3
    SERVO 16, 95
    SERVO 11, 100
    ETX 4800,52
    GOTO RX_EXIT
    '******************************************
전방100도:

    SPEED 3
    SERVO 16, 100
    SERVO 11, 100
    ETX 4800,53
    GOTO RX_EXIT

    '******************************************
    '******************************************
앞뒤기울기측정:
    FOR i = 0 TO COUNT_MAX
        A = AD(앞뒤기울기AD포트)	'기울기 앞뒤
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF A < MIN THEN
        GOSUB 기울기앞
    ELSEIF A > MAX THEN
        GOSUB 기울기뒤
    ENDIF

    RETURN
    '**************************************************
기울기앞:
    A = AD(앞뒤기울기AD포트)
    'IF A < MIN THEN GOSUB 앞으로일어나기
    IF A < MIN THEN
        ETX  4800,16
        GOSUB 뒤로일어나기
        ETX  4800,38
    ENDIF
    RETURN

기울기뒤:
    A = AD(앞뒤기울기AD포트)
    'IF A > MAX THEN GOSUB 뒤로일어나기
    IF A > MAX THEN
        ETX  4800,15
        GOSUB 앞으로일어나기
        ETX  4800,38
    ENDIF
    RETURN
    '**************************************************
좌우기울기측정:
    FOR i = 0 TO COUNT_MAX
        B = AD(좌우기울기AD포트)	'기울기 좌우
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB 기본자세	
    ENDIF
    RETURN
    '******************************************
    '************************************************
SOUND_PLAY_CHK:
    DELAY 60
    SOUND_BUSY = IN(46)
    IF SOUND_BUSY = 1 THEN GOTO SOUND_PLAY_CHK
    DELAY 50

    RETURN
    '************************************************

    '************************************************
NUM_1_9:
    IF NUM = 1 THEN
        PRINT "1"
    ELSEIF NUM = 2 THEN
        PRINT "2"
    ELSEIF NUM = 3 THEN
        PRINT "3"
    ELSEIF NUM = 4 THEN
        PRINT "4"
    ELSEIF NUM = 5 THEN
        PRINT "5"
    ELSEIF NUM = 6 THEN
        PRINT "6"
    ELSEIF NUM = 7 THEN
        PRINT "7"
    ELSEIF NUM = 8 THEN
        PRINT "8"
    ELSEIF NUM = 9 THEN
        PRINT "9"
    ELSEIF NUM = 0 THEN
        PRINT "0"
    ENDIF

    RETURN
    '************************************************
    '************************************************
NUM_TO_ARR:

    NO_4 =  BUTTON_NO / 10000
    TEMP_INTEGER = BUTTON_NO MOD 10000

    NO_3 =  TEMP_INTEGER / 1000
    TEMP_INTEGER = BUTTON_NO MOD 1000

    NO_2 =  TEMP_INTEGER / 100
    TEMP_INTEGER = BUTTON_NO MOD 100

    NO_1 =  TEMP_INTEGER / 10
    TEMP_INTEGER = BUTTON_NO MOD 10

    NO_0 =  TEMP_INTEGER

    RETURN
    '************************************************
Number_Play: '  BUTTON_NO = 숫자대입


    GOSUB NUM_TO_ARR

    PRINT "NPL "
    '*************

    NUM = NO_4
    GOSUB NUM_1_9

    '*************
    NUM = NO_3
    GOSUB NUM_1_9

    '*************
    NUM = NO_2
    GOSUB NUM_1_9
    '*************
    NUM = NO_1
    GOSUB NUM_1_9
    '*************
    NUM = NO_0
    GOSUB NUM_1_9
    PRINT " !"

    ' GOSUB SOUND_PLAY_CHK
    '    PRINT "SND 16 !"
    '    GOSUB SOUND_PLAY_CHK
    RETURN
    '************************************************

    RETURN


    '******************************************

    ' ************************************************
적외선거리센서확인:

    적외선거리값 = AD(적외선AD포트)

    IF 적외선거리값 > 50 THEN '50 = 적외선거리값 = 25cm
        MUSIC "C"
        DELAY 200
    ENDIF


    RETURN

    '******************************************
변수값_음성값출력:

    J = AD(적외선AD포트)	'적외선거리값 읽기
    BUTTON_NO = J
    'GOSUB Number_Play
    'GOSUB SOUND_PLAY_CHK
    GOSUB GOSUB_RX_EXIT


    RETURN

    '************************************************
골프_왼쪽으로_샷1:

    CONST 골프채높이 = 135

    GOSUB Arm_motor_mode3

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    'MOVE G6C,135,  20,  90, 10
    'WAIT

    MOVE G6C,130,  20,  90, 10
    WAIT


    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 8
    MOVE G6C,130,  10,  70, 10
    WAIT
    DELAY 1000
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '************************************************
골프_왼쪽으로_샷2:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  20,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 2
    'SPEED 15
    MOVE G6C,130,  10,  85, 10

    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '******************************************
    '************************************************
골프_왼쪽으로_샷3:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 3
    'SPEED 15
    MOVE G6C,130,  10,  85, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '************************************************
골프_왼쪽으로_샷4:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 4
    'SPEED 15
    MOVE G6C,130,  10,  85, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '************************************************
골프_왼쪽으로_샷5:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 5
    'SPEED 15
    MOVE G6C,130,  10,  85, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '************************************************
골프_왼쪽으로_샷6:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 6
    'SPEED 15
    MOVE G6C,130,  10,  85, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '************************************************
골프_왼쪽으로_샷6_1:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 6
    'SPEED 15
    MOVE G6C,130,  10,  84, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '************************************************
골프_왼쪽으로_샷6_2:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 6
    'SPEED 15
    MOVE G6C,130,  10,  83, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '************************************************
골프_왼쪽으로_샷6_3:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 6
    'SPEED 15
    MOVE G6C,130,  10,  82, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '************************************************
골프_왼쪽으로_샷6_4:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 6
    'SPEED 15
    MOVE G6C,130,  10,  81, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '************************************************
골프_왼쪽으로_샷6_5:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 6
    'SPEED 15
    MOVE G6C,130,  10,  80, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '************************************************
골프_왼쪽으로_샷7:

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 7
    'SPEED 15
    MOVE G6C,130,  10,  80, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '************************************************
골프_왼쪽으로_샷8:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 8
    'SPEED 15
    MOVE G6C,130,  10,  80, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '************************************************
골프_왼쪽으로_샷8_3:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 5
    'SPEED 15
    MOVE G6C,130,  10,  78, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN


    '************************************************
골프_왼쪽으로_샷8_4:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 5
    'SPEED 15
    MOVE G6C,130,  10,  76, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN

    '************************************************
골프_왼쪽으로_샷8_5:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 5
    'SPEED 15
    MOVE G6C,130,  10,  74, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN

    '************************************************
골프_왼쪽으로_샷9:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 7
    'SPEED 15
    MOVE G6C,130,  10,  74, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '************************************************
골프_왼쪽으로_샷10:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 9
    'SPEED 15
    MOVE G6C,130,  10,  74, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '************************************************
골프_왼쪽으로_샷11:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 9
    'SPEED 15
    MOVE G6C,130,  10,  72, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '************************************************
골프_왼쪽으로_샷12:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 9
    'SPEED 15
    MOVE G6C,130,  10,  70, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '************************************************
골프_왼쪽으로_샷13:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 10
    'SPEED 15
    MOVE G6C,130,  10,  70, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '************************************************
골프_왼쪽으로_샷14:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 11
    'SPEED 15
    MOVE G6C,130,  10,  70, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '************************************************
골프_왼쪽으로_샷15:


    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,130,  25,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,130,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 12
    'SPEED 15
    MOVE G6C,130,  10,  70, 10
    WAIT
    DELAY 500
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,130,  100,  10, 10
    WAIT

    MOVE G6C,130,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN

    '************************************************

골프_왼쪽으로_어드레스1:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT


    MOVE G6C,135,  20,  90, 10
    WAIT

    RETURN
    '******************************************

    '************************************************
골프_오른쪽으로_샷1:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  130,  10, 10
    WAIT

    MOVE G6C,130,  130,  10, 10
    WAIT

    MOVE G6C,130,  60,  10, 10
    WAIT

    MOVE G6C,130,  40,  30, 10
    WAIT


    MOVE G6C,130,  10,  80, 10
    WAIT

    DELAY 400

    MOVE G6B,100,  35,  90,
    MOVE G6C,130,  10,  70, 10
    WAIT


    '**** 골프 _오른쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 3

    MOVE G6C,130,  30,  100, 10
    WAIT
    DELAY 1000
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,170,  15,  90, 10
    WAIT

    MOVE G6C,170,  50,  60, 190
    WAIT

    GOSUB 기본자세


    RETURN


    RETURN
    '************************************************
골프_오른쪽으로_샷2:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  117,  10, 10
    WAIT

    MOVE G6C,150,  117,  10, 10
    WAIT

    MOVE G6C,150,  60,  10, 10
    WAIT

    MOVE G6C,131,  40,  30, 10
    WAIT


    MOVE G6C,131,  10,  60, 10
    WAIT

    DELAY 400

    MOVE G6B,100,  35,  90,
    MOVE G6C,131,  10,  70, 10
    WAIT


    '**** 골프 _오른쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 5

    MOVE G6C,131,  15,  90, 10
    WAIT
    DELAY 2000
    ' HIGHSPEED SETOFF


    SPEED 8
    'MOVE G6C, 131,  10,  55,  ,  ,
    MOVE G6C,150,  100,  10, 10
    WAIT

    'MOVE G6C, 131,  10,  55, 190
    MOVE G6C,110,  100,  10, 10
    WAIT

    MOVE G6C,110,  115,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '************************************************
골프_오른쪽으로_샷3:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  130,  10, 10
    WAIT

    MOVE G6C,150,  117,  10, 10
    WAIT

    MOVE G6C,150,  60,  10, 10
    WAIT

    MOVE G6C,131,  40,  30, 10
    WAIT


    MOVE G6C,131,  10,  60, 10
    WAIT

    DELAY 400

    MOVE G6B,100,  35,  90,
    MOVE G6C,129,  10,  70, 10
    WAIT


    '**** 골프 _오른쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 8

    MOVE G6C,129,  33	,  75, 10
    WAIT
    DELAY 2000
    ' HIGHSPEED SETOFF


    SPEED 8
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,110,  100,  10, 10
    WAIT

    MOVE G6C,110,  115,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '************************************************
골프_오른쪽으로_샷4:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  130,  10, 10
    WAIT

    MOVE G6C,150,  117,  10, 10
    WAIT

    MOVE G6C,150,  60,  10, 10
    WAIT

    MOVE G6C,131,  40,  30, 10
    WAIT


    MOVE G6C,131,  10,  60, 10
    WAIT

    DELAY 400

    MOVE G6B,100,  35,  90,
    MOVE G6C,129,  10,  70, 10
    WAIT


    '**** 골프 _오른쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 8

    MOVE G6C,129,  36	,  75, 10
    WAIT
    DELAY 2000
    ' HIGHSPEED SETOFF


    SPEED 8
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,110,  100,  10, 10
    WAIT

    MOVE G6C,110,  115,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 190
    WAIT

    GOSUB 기본자세


    RETURN

    '******************************************
    '************************************************
골프_오른쪽으로_샷5:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  130,  10, 10
    WAIT

    MOVE G6C,150,  117,  10, 10
    WAIT

    MOVE G6C,150,  60,  10, 10
    WAIT

    MOVE G6C,131,  40,  30, 10
    WAIT


    MOVE G6C,131,  10,  60, 10
    WAIT

    DELAY 400

    MOVE G6B,100,  35,  90,
    MOVE G6C,129,  10,  70, 10
    WAIT


    '**** 골프 _오른쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 8

    MOVE G6C,129,  39	,  75, 10
    WAIT
    DELAY 2000
    ' HIGHSPEED SETOFF


    SPEED 8
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,110,  100,  10, 10
    WAIT

    MOVE G6C,110,  115,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '******************************************
골프_오른쪽으로_샷6:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  130,  10, 10
    WAIT

    MOVE G6C,150,  117,  10, 10
    WAIT

    MOVE G6C,150,  60,  10, 10
    WAIT

    MOVE G6C,131,  40,  30, 10
    WAIT


    MOVE G6C,131,  10,  60, 10
    WAIT

    DELAY 400

    MOVE G6B,100,  35,  90,
    MOVE G6C,129,  10,  70, 10
    WAIT


    '**** 골프 _오른쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 8

    MOVE G6C,129,  42	,  75, 10
    WAIT
    DELAY 2000
    ' HIGHSPEED SETOFF


    SPEED 8
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,110,  100,  10, 10
    WAIT

    MOVE G6C,110,  115,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 190
    WAIT

    GOSUB 기본자세


    RETURN
    '******************************************
골프_오른쪽으로_샷7:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  130,  10, 10
    WAIT

    MOVE G6C,150,  117,  10, 10
    WAIT

    MOVE G6C,150,  60,  10, 10
    WAIT

    MOVE G6C,131,  40,  30, 10
    WAIT


    MOVE G6C,131,  10,  60, 10
    WAIT

    DELAY 400

    MOVE G6B,100,  35,  90,
    MOVE G6C,129,  10,  70, 10
    WAIT


    '**** 골프 _오른쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 10

    MOVE G6C,129,  42	,  75, 10
    WAIT
    DELAY 2000
    ' HIGHSPEED SETOFF


    SPEED 8
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,110,  100,  10, 10
    WAIT

    MOVE G6C,110,  115,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 190
    WAIT

    GOSUB 기본자세


    RETURN
 '******************************************
골프_오른쪽으로_샷8:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  130,  10, 10
    WAIT

    MOVE G6C,150,  117,  10, 10
    WAIT

    MOVE G6C,150,  60,  10, 10
    WAIT

    MOVE G6C,131,  40,  30, 10
    WAIT


    MOVE G6C,131,  10,  60, 10
    WAIT

    DELAY 400

    MOVE G6B,100,  35,  90,
    MOVE G6C,129,  10,  70, 10
    WAIT


    '**** 골프 _오른쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 12

    MOVE G6C,129,  42	,  75, 10
    WAIT
    DELAY 2000
    ' HIGHSPEED SETOFF


    SPEED 8
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,110,  100,  10, 10
    WAIT

    MOVE G6C,110,  115,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 190
    WAIT

    GOSUB 기본자세


    RETURN
'******************************************
골프_오른쪽으로_샷9:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  130,  10, 10
    WAIT

    MOVE G6C,150,  117,  10, 10
    WAIT

    MOVE G6C,150,  60,  10, 10
    WAIT

    MOVE G6C,131,  40,  30, 10
    WAIT


    MOVE G6C,131,  10,  60, 10
    WAIT

    DELAY 400

    MOVE G6B,100,  35,  90,
    MOVE G6C,129,  10,  70, 10
    WAIT


    '**** 골프 _오른쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 14

    MOVE G6C,129,  42	,  75, 10
    WAIT
    DELAY 2000
    ' HIGHSPEED SETOFF


    SPEED 8
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,110,  100,  10, 10
    WAIT

    MOVE G6C,110,  115,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 190
    WAIT

    GOSUB 기본자세


    RETURN
'******************************************
골프_오른쪽으로_샷10:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  130,  10, 10
    WAIT

    MOVE G6C,150,  117,  10, 10
    WAIT

    MOVE G6C,150,  60,  10, 10
    WAIT

    MOVE G6C,131,  40,  30, 10
    WAIT


    MOVE G6C,131,  10,  60, 10
    WAIT

    DELAY 400

    MOVE G6B,100,  35,  90,
    MOVE G6C,129,  10,  70, 10
    WAIT


    '**** 골프 _오른쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 16

    MOVE G6C,129,  42	,  75, 10
    WAIT
    DELAY 2000
    ' HIGHSPEED SETOFF


    SPEED 8
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,110,  100,  10, 10
    WAIT

    MOVE G6C,110,  115,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 190
    WAIT

    GOSUB 기본자세


    RETURN
'******************************************
골프_오른쪽으로_샷11:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  130,  10, 10
    WAIT

    MOVE G6C,150,  117,  10, 10
    WAIT

    MOVE G6C,150,  60,  10, 10
    WAIT

    MOVE G6C,131,  40,  30, 10
    WAIT


    MOVE G6C,131,  10,  60, 10
    WAIT

    DELAY 400

    MOVE G6B,100,  35,  90,
    MOVE G6C,129,  10,  70, 10
    WAIT


    '**** 골프 _오른쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 18

    MOVE G6C,129,  42	,  75, 10
    WAIT
    DELAY 2000
    ' HIGHSPEED SETOFF


    SPEED 8
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,110,  100,  10, 10
    WAIT

    MOVE G6C,110,  115,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 190
    WAIT

    GOSUB 기본자세


    RETURN

'******************************************
골프_오른쪽으로_샷12:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  130,  10, 10
    WAIT

    MOVE G6C,150,  117,  10, 10
    WAIT

    MOVE G6C,150,  60,  10, 10
    WAIT

    MOVE G6C,131,  40,  30, 10
    WAIT


    MOVE G6C,131,  10,  60, 10
    WAIT

    DELAY 400

    MOVE G6B,100,  35,  90,
    MOVE G6C,129,  10,  70, 10
    WAIT


    '**** 골프 _오른쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 20

    MOVE G6C,129,  42	,  75, 10
    WAIT
    DELAY 2000
    ' HIGHSPEED SETOFF


    SPEED 8
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,110,  100,  10, 10
    WAIT

    MOVE G6C,110,  115,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 190
    WAIT

    GOSUB 기본자세


    RETURN
'******************************************
골프_오른쪽으로_샷13:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  130,  10, 10
    WAIT

    MOVE G6C,150,  117,  10, 10
    WAIT

    MOVE G6C,150,  60,  10, 10
    WAIT

    MOVE G6C,131,  40,  30, 10
    WAIT


    MOVE G6C,131,  10,  60, 10
    WAIT

    DELAY 400

    MOVE G6B,100,  35,  90,
    MOVE G6C,129,  10,  70, 10
    WAIT


    '**** 골프 _오른쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 22

    MOVE G6C,129,  42	,  75, 10
    WAIT
    DELAY 2000
    ' HIGHSPEED SETOFF


    SPEED 8
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,110,  100,  10, 10
    WAIT

    MOVE G6C,110,  115,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 10
    WAIT

    MOVE G6C,90,  130,  10, 190
    WAIT

    GOSUB 기본자세


    RETURN

    '******************************************

우측시야확보1:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 65
    ETX 4800,89
    GOTO RX_EXIT


    '******************************************
우측시야확보2:
    GOSUB All_motor_mode3

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,10,  30,  80, 190
    ETX 4800,90
    GOTO RX_EXIT

    '******************************************


골프_오른쪽으로_어드레스1:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT


    MOVE G6C,135,  40,  40, 10
    WAIT

    MOVE G6C,135,  10,  80, 10
    WAIT


    RETURN
    '******************************************
    '******************************************	
MAIN: '라벨설정

    ETX 4800, 38 ' 동작 멈춤 확인 송신 값

MAIN_2:

    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정
    'GOSUB 적외선거리센서확인


    ERX 4800,A,MAIN_2	

    A_old = A

    '**** 입력된 A값이 0 이면 MAIN 라벨로 가고
    '**** 1이면 KEY1 라벨, 2이면 key2로... 가는문
    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18 ,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28 ,KEY29,KEY30,KEY31,KEY32,KEY33,KEY34,KEY35,KEY36,KEY37,KEY38,KEY39,KEY40,KEY41,KEY42,KEY43,KEY44,KEY45,KEY46,KEY47,KEY48,KEY49,KEY50,KEY51,KEY52,KEY53,KEY54,KEY55,KEY56,KEY57,KEY58,KEY59,KEY60,KEY61,KEY62,KEY63,KEY64,KEY65,KEY66,KEY67,KEY68,KEY69,KEY70,KEY71,KEY72,KEY73,KEY74,KEY75,KEY76,KEY77,KEY78,KEY79,KEY80,KEY81,KEY82,KEY83,KEY84,KEY85,KEY86,KEY87,KEY88,KEY89,KEY90,KEY91,KEY92,KEY93,KEY94,KEY95,KEY96,KEY97,KEY98,KEY99,KEY100

    IF A > 100 AND A < 110 THEN
        BUTTON_NO = A - 100
        GOSUB Number_Play
        'GOSUB SOUND_PLAY_CHK
        GOSUB GOSUB_RX_EXIT


    ELSEIF A = 250 THEN
        GOSUB All_motor_mode3
        SPEED 4
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  40,  90,
        MOVE G6C,100,  40,  90,
        WAIT
        DELAY 500
        SPEED 6
        GOSUB 기본자세

    ENDIF


    GOTO MAIN	
    '*******************************************
    '		MAIN 라벨로 가기
    '*******************************************

KEY1:
    ETX  4800,1
    GOTO 왼쪽턴5_골프
    'GOSUB 골프_오른쪽으로_샷6
    GOTO RX_EXIT
    '***************	
KEY2:
    ETX  4800,2

    GOSUB 골프_오른쪽으로_샷3

    GOTO RX_EXIT
    '***************
KEY3:
    ETX  4800,3

    GOTO 오른쪽턴5_골프
    'GOSUB gofoward_LL4

    GOTO RX_EXIT
    '***************
KEY4:
    ETX  4800,4

    GOTO 왼쪽턴10_골프
    'GOTO 왼쪽옆으로10_골프

    GOTO RX_EXIT
    '***************
KEY5:
    ETX  4800,5

    GOSUB gofoward_H2

    GOTO RX_EXIT
    '***************
KEY6:
    ETX  4800,6

    GOTO 오른쪽턴10_골프


    GOTO RX_EXIT
    '***************
KEY7:
    ETX  4800,7
    GOTO 왼쪽턴20_골프

    GOTO RX_EXIT
    '***************
    'KEY8:
    'ETX  4800, 8
    'GOTO

    'GOTO RX_EXIT
    '***************
KEY9:
    ETX  4800,9
    GOTO 오른쪽턴20_골프


    GOTO RX_EXIT
    '***************
KEY10: '0
    ETX  4800,10
    GOTO 전진종종걸음_골프

    GOTO RX_EXIT
    '***************
KEY11: ' ▲
    ETX  4800,11

    GOTO 연속전진_골프

    GOTO RX_EXIT
    '***************
KEY12: ' ▼
    ETX  4800,12
    GOTO 연속후진_골프

    GOTO RX_EXIT
    '***************
KEY13: '▶
    ETX  4800,13
    GOTO 오른쪽옆으로70연속_골프


    GOTO RX_EXIT
    '***************
KEY14: ' ◀
    ETX  4800,14
    GOTO 왼쪽옆으로70연속_골프


    GOTO RX_EXIT
    '***************
KEY15: ' A
    ETX  4800,15
    GOTO 왼쪽옆으로20_골프


    GOTO RX_EXIT
    '***************
KEY16: ' POWER
    ETX  4800,16

    GOSUB Leg_motor_mode3
    IF MODE = 0 THEN
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT
    ENDIF
    SPEED 4
    GOSUB 앉은자세	
    GOSUB 종료음

    GOSUB MOTOR_GET
    GOSUB MOTOR_OFF


    GOSUB GOSUB_RX_EXIT
KEY16_1:

    IF 모터ONOFF = 1  THEN
        OUT 52,1
        DELAY 200
        OUT 52,0
        DELAY 200
    ENDIF
    ERX 4800,A,KEY16_1
    ETX  4800,A

    '**** RX DATA Number Sound ********
    BUTTON_NO = A
    GOSUB Number_Play
    GOSUB SOUND_PLAY_CHK


    IF  A = 16 THEN 	'다시 파워버튼을 눌러야만 복귀
        GOSUB MOTOR_ON
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT

        GOSUB 기본자세2
        GOSUB 자이로ON
        GOSUB All_motor_mode3
        GOTO RX_EXIT
    ENDIF

    GOSUB GOSUB_RX_EXIT
    GOTO KEY16_1



    GOTO RX_EXIT
    '***************
KEY17: ' C
    ETX  4800,17
    GOTO 머리왼쪽90도


    GOTO RX_EXIT
    '***************
KEY18: ' E
    ETX  4800,18	


    GOSUB 자이로OFF
    GOSUB 에러음
KEY18_wait:

    ERX 4800,A,KEY18_wait	

    IF  A = 26 THEN
        GOSUB 시작음
        GOSUB 자이로ON
        GOTO RX_EXIT
    ENDIF

    GOTO KEY18_wait


    GOTO RX_EXIT
    '***************
KEY19: ' P2
    ETX  4800,19
    GOTO 오른쪽턴60_골프

    GOTO RX_EXIT
    '***************
KEY20: ' B	
    ETX  4800,20
    GOTO 오른쪽옆으로20_골프


    GOTO RX_EXIT
    '***************
KEY21: ' △
    ETX  4800,21
    GOTO 머리좌우중앙

    GOTO RX_EXIT
    '***************
KEY22: ' *	
    ETX  4800,22
    GOTO 왼쪽턴45_골프

    GOTO RX_EXIT
    '***************
KEY23: ' G
    ETX  4800,23
    GOSUB 골프_왼쪽으로_샷12



    GOTO RX_EXIT
    '***************
KEY24: ' #
    ETX  4800,24
    GOTO 오른쪽턴45_골프

    GOTO RX_EXIT
    '***************
KEY25: ' P1
    ETX  4800,25
    GOTO 왼쪽턴60_골프

    GOTO RX_EXIT
    '***************
KEY26: ' ■
    ETX  4800,26

    SPEED 5
    GOSUB 기본자세2	
    TEMPO 220
    MUSIC "ff"
    GOSUB 기본자세
    GOTO RX_EXIT
    '***************
KEY27: ' D
    ETX  4800,27
    GOTO 머리오른쪽90도


    GOTO RX_EXIT
    '***************
KEY8:
    ETX  4800,8
    GOSUB 정지동작고개100


    GOTO RX_EXIT
    '***************
KEY28: ' ◁
    ETX  4800,28
    GOTO 머리왼쪽45도


    GOTO RX_EXIT
    '***************
KEY29: ' □
    ETX  4800,29

    GOTO CCW_걸음

    GOTO RX_EXIT
    '***************
KEY30: ' ▷
    ETX  4800,30
    GOTO CCW_회전6

    GOTO RX_EXIT
    '***************
KEY31: ' ▽
    ETX  4800,31
    GOTO 전방하향60도

    GOTO RX_EXIT
    '***************

KEY32: ' F
    ETX  4800,32
    GOTO 후진종종걸음_골프
    GOTO RX_EXIT
    '***************
KEY33: ' 오른쪽옆10
    ETX  4800,33
    GOTO 오른쪽옆으로10_골프


    GOTO RX_EXIT
    '***************
KEY34: ' 왼쪽옆10
    ETX  4800,34
    GOTO 왼쪽옆으로10_골프_2


    GOTO RX_EXIT
    '***************
KEY35:
    ETX  4800,35


    GOTO 전진_한걸음


    GOTO RX_EXIT
    '***************
KEY36:
    ETX  4800,36


    GOSUB gofoward_LL4


    GOTO RX_EXIT
    '***************
KEY37:
    ETX  4800,37


    GOSUB gofoward_H1


    GOTO RX_EXIT
    '***************
KEY38:
    ETX  4800,38


    GOTO RX_EXIT
    '***************
KEY39:
    ETX  4800,39


    GOSUB goback_L2


    GOTO RX_EXIT
    '***************
KEY40: ' G
    ETX  4800,40
    GOTO 전방35도



    GOTO RX_EXIT
    '***************
KEY41: ' G
    ETX  4800,41
    GOTO 전방40도

    GOTO RX_EXIT
    '***************
KEY42: ' G
    ETX  4800,42
    GOTO 전방45도

    GOTO RX_EXIT
    '***************
KEY43: ' G
    ETX  4800,43
    GOTO 전방50도

    GOTO RX_EXIT
    '***************
KEY44: ' G
    ETX  4800,44
    GOTO 전방55도

    GOTO RX_EXIT
    '***************
KEY45: ' G
    ETX  4800,45
    GOTO 전방60도

    GOTO RX_EXIT
    '***************
KEY46: ' G
    ETX  4800,46
    GOTO 전방65도

    GOTO RX_EXIT
    '***************
KEY47: ' G
    ETX  4800,47
    GOTO 전방70도

    GOTO RX_EXIT
    '***************
KEY48: ' G
    ETX  4800,48
    GOTO 전방75도

    GOTO RX_EXIT
    '***************
KEY49: ' G
    ETX  4800,49
    GOTO 전방80도

    GOTO RX_EXIT
    '***************
KEY50: ' G
    ETX  4800,50
    GOTO 전방85도

    GOTO RX_EXIT
    '***************
KEY51: ' G
    ETX  4800,51
    GOTO 전방90도

    GOTO RX_EXIT
    '***************
KEY52: ' G
    ETX  4800,52
    GOTO 전방95도

    GOTO RX_EXIT
    '***************
KEY53: ' G
    ETX  4800,53
    GOTO 전방100도

    GOTO RX_EXIT
    '***************
KEY54: ' G
    ETX  4800,54
    GOTO CW_걸음

    GOTO RX_EXIT
    '***************
KEY55: ' ▷
    ETX  4800,55
    GOTO CW_회전3

    GOTO RX_EXIT
    '***************	
KEY56:
    ETX  4800,56


    GOSUB 골프_왼쪽으로_샷1


    GOTO RX_EXIT
    '***************	
KEY57:
    ETX  4800,57


    GOSUB 골프_왼쪽으로_샷2


    GOTO RX_EXIT
    '***************	
KEY58:
    ETX  4800,58


    GOSUB 골프_왼쪽으로_샷3


    GOTO RX_EXIT
    '***************	
KEY59:
    ETX  4800,59


    GOSUB 골프_왼쪽으로_샷4


    GOTO RX_EXIT
    '***************	
KEY60:
    ETX  4800,60


    GOSUB 골프_왼쪽으로_샷5


    GOTO RX_EXIT
    '***************	
KEY61:
    ETX  4800,61


    GOSUB 골프_왼쪽으로_샷6


    GOTO RX_EXIT
    '***************	
KEY62:
    ETX  4800,62


    GOSUB 골프_왼쪽으로_샷6_1


    GOTO RX_EXIT
    '***************	
KEY63:
    ETX  4800,63


    GOSUB 골프_왼쪽으로_샷6_2


    GOTO RX_EXIT
    '***************	
KEY64:
    ETX  4800,64


    GOSUB 골프_왼쪽으로_샷6_3


    GOTO RX_EXIT
    '***************	
KEY65:
    ETX  4800,65


    GOSUB 골프_왼쪽으로_샷6_4


    GOTO RX_EXIT
    '***************	
KEY66:
    ETX  4800, 66


    GOSUB 골프_왼쪽으로_샷6_5


    GOTO RX_EXIT
    '***************	
KEY67:
    ETX  4800,67


    GOSUB 골프_왼쪽으로_샷7


    GOTO RX_EXIT
    '***************	
KEY68:
    ETX  4800,68

    GOSUB 골프_왼쪽으로_샷8

    GOTO RX_EXIT
    '***************	
KEY69:
    ETX  4800,69

    GOSUB 골프_왼쪽으로_샷8_3


    GOTO RX_EXIT
    '***************	
KEY70:
    ETX  4800,70

    GOSUB 골프_왼쪽으로_샷8_4


    GOTO RX_EXIT
    '***************	
KEY71:
    ETX  4800,71

    GOSUB 골프_왼쪽으로_샷8_5

    GOTO RX_EXIT
    '***************	
KEY72:
    ETX  4800,72

    GOSUB 골프_왼쪽으로_샷9


    GOTO RX_EXIT
    '***************	
KEY73:
    ETX  4800,73

    GOSUB 골프_왼쪽으로_샷10


    GOTO RX_EXIT
    '***************	
KEY74:
    ETX  4800,74

    GOSUB 골프_왼쪽으로_샷11


    GOTO RX_EXIT
    '***************	
KEY75:
    ETX  4800,75

    GOSUB 골프_왼쪽으로_샷12


    GOTO RX_EXIT
    '***************	
KEY76:
    ETX  4800,76

    GOSUB 골프_왼쪽으로_샷13


    GOTO RX_EXIT
    '***************	
KEY77:
    ETX  4800,77

    GOSUB 골프_왼쪽으로_샷14


    GOTO RX_EXIT
    '***************	
KEY78:
    ETX  4800,78

    GOSUB 골프_왼쪽으로_샷15


    GOTO RX_EXIT
    '***************	
KEY79:
    ETX  4800,79




    GOTO RX_EXIT
    '***************	
KEY80:
    ETX  4800,80




    GOTO RX_EXIT
    '***************	
KEY81:
    ETX  4800,81

    GOSUB 골프_오른쪽으로_샷1


    GOTO RX_EXIT
    '***************	
KEY82:
    ETX  4800,82

    GOSUB 골프_오른쪽으로_샷2


    GOTO RX_EXIT
    '***************	
KEY83:
    ETX  4800,83

    GOTO 세레모니


    GOTO RX_EXIT
    '***************
KEY84: ' ▲
    ETX  4800,84

    GOTO 느린연속전진_골프

    GOTO RX_EXIT
    '***************
KEY85: ' ▲
    ETX  4800,85

    GOSUB 골프_오른쪽으로_샷3

    GOTO RX_EXIT
    '***************
KEY86: ' ▲
    ETX  4800,86

    GOTO CCW_회전7

    GOTO RX_EXIT
    '***************
KEY87: ' ▲
    ETX  4800,87

    GOTO CW_회전7

    GOTO RX_EXIT
    '***************
KEY88: ' ▲
    ETX  4800,88

    GOTO CCW_회전8

    GOTO RX_EXIT
    '***************
KEY89: ' ▲
    ETX  4800,89

    GOTO 우측시야확보1

    GOTO RX_EXIT
    '***************
KEY90: ' ▲
    ETX  4800,90

    GOTO 우측시야확보2

    GOTO RX_EXIT
    '***************
KEY91: ' ▲
    ETX  4800,91

    GOSUB 골프_오른쪽으로_샷4

    GOTO RX_EXIT
    '***************
KEY92: ' ▲
    ETX  4800,92

    GOSUB 골프_오른쪽으로_샷5

    GOTO RX_EXIT
    '***************
KEY93: ' ▲
    ETX  4800,93

    GOSUB 골프_오른쪽으로_샷6

    GOTO RX_EXIT
    '***************
KEY94: ' ▲
    ETX  4800,94

    GOSUB 골프_오른쪽으로_샷7

    GOTO RX_EXIT
'***************
KEY95: ' ▲
    ETX  4800,95

    GOSUB 골프_오른쪽으로_샷8

    GOTO RX_EXIT
'***************
KEY96: ' ▲
    ETX  4800,96

    GOSUB 골프_오른쪽으로_샷9

    GOTO RX_EXIT
'***************
KEY97: ' ▲
    ETX  4800,97

    GOSUB 골프_오른쪽으로_샷10

    GOTO RX_EXIT
'***************
KEY98: ' ▲
    ETX  4800,97

    GOSUB 골프_오른쪽으로_샷11

    GOTO RX_EXIT
'***************
KEY99: ' ▲
    ETX  4800,97

    GOSUB 골프_오른쪽으로_샷12

    GOTO RX_EXIT
'***************
KEY100: ' ▲
    ETX  4800,97

    GOSUB 골프_오른쪽으로_샷13

    GOTO RX_EXIT

