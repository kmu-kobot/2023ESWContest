'******** 2�� ����κ� �ʱ� ���� ���α׷� ********

DIM I AS BYTE
DIM J AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM ����ӵ� AS BYTE
DIM �¿�ӵ� AS BYTE
DIM �¿�ӵ�2 AS BYTE
DIM ������� AS BYTE
DIM �������� AS BYTE
DIM ����üũ AS BYTE
DIM ����ONOFF AS BYTE
DIM ���̷�ONOFF AS BYTE
DIM ����յ� AS INTEGER
DIM �����¿� AS INTEGER

DIM ����� AS BYTE

DIM �Ѿ���Ȯ�� AS BYTE
DIM ����Ȯ��Ƚ�� AS BYTE
DIM ����Ƚ�� AS BYTE
DIM ����COUNT AS BYTE

DIM ���ܼ��Ÿ���  AS BYTE

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

'**** ���⼾����Ʈ ���� ****
CONST �յڱ���AD��Ʈ = 0
CONST �¿����AD��Ʈ = 1
CONST ����Ȯ�νð� = 20  'ms

CONST ���ܼ�AD��Ʈ  = 4


CONST min = 61	'�ڷγѾ�������
CONST max = 107	'�����γѾ�������
CONST COUNT_MAX = 3


CONST �Ӹ��̵��ӵ� = 10
'************************************************



PTP SETON 				'�����׷캰 ���������� ����
PTP ALLON				'��ü���� ������ ���� ����

DIR G6A,1,0,0,1,0,0		'����0~5��
DIR G6D,0,1,1,0,1,1		'����18~23��
DIR G6B,1,1,1,1,1,1		'����6~11��
DIR G6C,0,0,0,1,1,0		'����12~17��

'************************************************

OUT 52,0	'�Ӹ� LED �ѱ�
'***** �ʱ⼱�� '************************************************

������� = 0
����üũ = 0
����Ȯ��Ƚ�� = 0
����Ƚ�� = 1
����ONOFF = 0

'****�ʱ���ġ �ǵ��*****************************


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


GOSUB �����ʱ��ڼ�
GOSUB �⺻�ڼ�


GOSUB ���̷�INIT
GOSUB ���̷�MID
GOSUB ���̷�ON



'PRINT "VOLUME 200 !"
'PRINT "SOUND 12 !" '�ȳ��ϼ���

'GOSUB All_motor_mode3





GOTO MAIN	'�ø��� ���� ��ƾ���� ����

'************************************************

'*********************************************
' Infrared_Distance = 60 ' About 20cm
' Infrared_Distance = 50 ' About 25cm
' Infrared_Distance = 30 ' About 45cm
' Infrared_Distance = 20 ' About 65cm
' Infrared_Distance = 10 ' About 95cm
'*********************************************
'************************************************
������:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
������:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
������:
    TEMPO 250
    MUSIC "FFF"
    RETURN
    '************************************************
    '************************************************
MOTOR_ON: '����Ʈ�������ͻ�뼳��

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    ����ONOFF = 0
    GOSUB ������			
    RETURN

    '************************************************
    '����Ʈ�������ͻ�뼳��
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    ����ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB ������	
    RETURN
    '************************************************
    '��ġ���ǵ��
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,1,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
    '��ġ���ǵ��
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

�����ʱ��ڼ�:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90, 190
    WAIT
    mode = 0
    RETURN
    '************************************************
����ȭ�ڼ�:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90, 190
    WAIT
    mode = 0

    RETURN
    '******************************************	


    '************************************************
�⺻�ڼ�:


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
�⺻�ڼ�2:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    mode = 0
    RETURN
    '******************************************	
�⺻�ڼ�3:
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
�����ڼ�:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT
    mode = 2
    RETURN
    '******************************************
�����ڼ�:
    GOSUB ���̷�OFF
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
    '**** ���̷ΰ��� ���� ****
���̷�INIT:

    GYRODIR G6A, 0, 0, 1, 0,0
    GYRODIR G6D, 1, 0, 1, 0,0

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
    '**** ���̷ΰ��� ���� ****
���̷�MAX:

    GYROSENSE G6A,250,180,30,180,0
    GYROSENSE G6D,250,180,30,180,0

    RETURN
    '***********************************************
���̷�MID:

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
���̷�MIN:

    GYROSENSE G6A,200,100,30,100,0
    GYROSENSE G6D,200,100,30,100,0
    RETURN
    '***********************************************
���̷�ON:

    GYROSET G6A, 4, 3, 3, 3, 0
    GYROSET G6D, 4, 3, 3, 3, 0

    ���̷�ONOFF = 1

    RETURN
    '***********************************************
���̷�OFF:

    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0


    ���̷�ONOFF = 0
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
����_�Ѱ���:
    ����COUNT = 0
    ����ӵ� = 13
    �¿�ӵ� = 4
    �Ѿ���Ȯ�� = 0

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

    '������ ������
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
    '�����߷� �����߽�

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
    '�ѹ� ����� �ϼ�
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

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0

        GOTO RX_EXIT
    ENDIF

    'SPEED 5
    GOSUB �⺻�ڼ�2
    RETURN

    '**********************************************
gofoward_H2:
    GOSUB All_motor_mode3
    'GOSUB Leg_motor_mode3
    '�����߷� �����߽�

    SPEED 3
    '������ �����߽�
    MOVE G6A,  94,  74, 145, 100, 101,
    MOVE G6D, 106,  79, 135, 104, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT
    '������ �����߽� + �޹� ���
    SPEED 5
    MOVE G6A,  88,  78, 141,  97, 111,
    MOVE G6D, 112,  78, 146,  93,  99,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  32,  81,  ,  ,
    WAIT

    SPEED 3
    '�����߽� �߾� + �޹� �����ϼ�
    MOVE G6A,  98,  68, 138, 114, 102,
    MOVE G6D, 102,  78, 139, 102, 101,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  33,  82,  ,  ,
    WAIT

    DELAY 95
    '�޹� ����� + �����߽� �޹�
    MOVE G6A, 108,  70, 138, 116, 101,
    MOVE G6D,  92,  80, 139, 104, 103,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  33,  82,  ,  ,
    WAIT

    SPEED 5
    '�޹� ���� ������ + ������ ������ �������(���ϼ���)
    MOVE G6A, 114,  94, 114, 114,  99,
    MOVE G6D,  84,  89, 113, 112, 113,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0

        GOTO RX_EXIT
    ENDIF

    SPEED 3
    GOSUB �⺻�ڼ�2
    RETURN

    '**********************************************

������������_����:
    ����COUNT = 0
    ����ӵ� = 8
    �¿�ӵ� = 4
    �Ѿ���Ȯ�� = 0

    GOSUB Leg_motor_mode3


    SPEED 4
    '�����߿� �����߽�
    MOVE G6A, 88,  74, 144,  95, 110
    MOVE G6D,108,  76, 146,  93,  96
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    SPEED 8'
    '������ �����߽� + �޹ߵ��good
    MOVE G6A,  92,  93, 120, 106, 110,
    MOVE G6D, 111,  77, 147,  94,  96,
    MOVE G6B,  90,  30,  80,  ,  ,
    MOVE G6C, 110,  30,  80,  ,  ,
    WAIT

    GOTO ������������_����_1
    '***************************************************

������������_����_1:
    GOSUB Leg_motor_mode3
    ETX 4800,11 '�����ڵ带 ����
    SPEED ����ӵ�
    '������ �����߽� + �޹� ������(�ָ��ϰ� �鸲)
    MOVE G6A,  93,  59, 145, 115, 107,
    MOVE G6D, 102,  76, 147,  95,  96,
    WAIT


    SPEED �¿�ӵ�
    'GOSUB Leg_motor_mode3
    '�޹� ���� + �޹� �����߽� + ������ ���(�ָ�)
    MOVE G6A, 106,  64, 144, 115,  96,
    MOVE G6D,  90,  80, 145,  95, 109,
    WAIT

    MOVE G6A, 114,  69, 144, 115,  96,
    MOVE G6D,  87,  82, 130, 110, 116,
    WAIT

    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, ������������_����_2
    IF A = 11 THEN
        GOTO ������������_����_2
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
        GOSUB �⺻�ڼ�2

        GOTO RX_EXIT
    ENDIF
    '**********

������������_����_2:
    '�޹� �����߽� + ������ ������ ��������(�����)
    GOSUB Leg_motor_mode3
    MOVE G6A, 114,  72, 147,  104,  96,
    MOVE G6D,  88,  83, 120, 114, 115,
    MOVE G6B, 110,  30,  80,  ,  ,
    MOVE G6C,  90,  30,  83,  ,  ,
    WAIT


������������_����_3:
    ETX 4800,11 '�����ڵ带 ����

    SPEED ����ӵ�

    MOVE G6A, 102,  83, 138, 101,  96,
    MOVE G6D,  98,  58, 145, 119, 107,
    WAIT



    '������ ������ + ������ �����߽�+�޹ߵ��
    SPEED �¿�ӵ�
    MOVE G6A,  97,  83, 138, 101, 100,
    MOVE G6D, 105,  58, 145, 119, 101,
    WAIT


    MOVE G6A,  90,  83, 130, 110, 116,
    MOVE G6D, 110,  69, 144, 115,  96,
    WAIT

    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, ������������_����_4
    IF A = 11 THEN
        GOTO ������������_����_4
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
        GOSUB �⺻�ڼ�2

        GOTO RX_EXIT
    ENDIF

������������_����_4:
    GOSUB Leg_motor_mode3
    '������ �����߽� + �޹� ������ ��������(������� + ����)
    MOVE G6A,  88,  94, 120, 105, 114,
    MOVE G6D, 112,  78, 146,  94,  98,
    MOVE G6B,  90,  30,  80,  ,  ,
    MOVE G6C, 110,  30,  83,  ,  ,
    WAIT

    GOTO ������������_����_1

    '**********************************************

��������_����:
    ����COUNT = 0
    ����ӵ� = 18
    �¿�ӵ� = 4
    �Ѿ���Ȯ�� = 0

    GOSUB Leg_motor_mode3
    SPEED 4

    MOVE G6D,  88,  74, 144,  95, 110
    MOVE G6A, 107,  76, 146,  93,  96
    MOVE G6C, 100
    MOVE G6B, 100
    WAIT

    SPEED 10


    GOTO ��������_����_2	


    '***************************************************

��������_����_1:

    ETX 4800,11 '�����ڵ带 ����
    SPEED ����ӵ�

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT


    SPEED �¿�ӵ�
    GOSUB Leg_motor_mode3

    'MOVE G6A,110,  76, 147, 93,  96
    MOVE G6A,112,  76, 147, 95,  96
    MOVE G6D,92, 94, 145,  71, 112
    WAIT

    SPEED 9
    MOVE G6A,113,  76, 147, 95,  96
    MOVE G6D,90, 86, 145,  80, 112
    WAIT


    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, ��������_����_2
    IF A = 11 THEN
        GOTO ��������_����_2
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
        GOSUB �⺻�ڼ�2

        GOTO RX_EXIT
    ENDIF
    '**********

��������_����_2:
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

��������_����_3:
    ETX 4800,11 '�����ڵ带 ����

    SPEED ����ӵ�

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, ��������_����_4
    IF A = 11 THEN
        GOTO ��������_����_4
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
        GOSUB �⺻�ڼ�2

        GOTO RX_EXIT
    ENDIF

��������_����_4:
    '�޹ߵ��10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    GOTO ��������_����_1
    '*******************************

    '************************************************
��������_����:
    �Ѿ���Ȯ�� = 0
    ����ӵ� = 8
    �¿�ӵ� = 4
    GOSUB Leg_motor_mode3



    IF ������� = 0 THEN
        ������� = 1

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

        GOTO ��������_����_1	
    ELSE
        ������� = 0

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


        GOTO ��������_����_2

    ENDIF

    '*************************************
goback_H1:
    GOSUB All_motor_mode3
    GOSUB Leg_motor_mode3	
    SPEED 4
    ����ӵ� = 12
    �¿�ӵ� = 4
    '�����߷� �����߽�
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 145,  93,  96
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    '��������_����: �޹ߵ��
    SPEED 10
    MOVE G6A, 95, 96, 100, 115, 110
    MOVE G6D,110,  76, 145,  93,  96
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    '��������_����_1: �޹߳���
    SPEED ����ӵ�

    MOVE G6D,110,  76, 146, 93,  96
    MOVE G6A,90, 98, 146,  69, 110
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D, 90,  60, 137, 120, 110
    MOVE G6A,107,  85, 137,  93,  96
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
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
    GOSUB �⺻�ڼ�2

    RETURN
    '*************************************
��������_����_1:
    ETX 4800,12 '�����ڵ带 ����
    SPEED ����ӵ�

    MOVE G6D,110,  76, 146, 93,  96
    MOVE G6A,90, 98, 146,  69, 110
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D, 90,  60, 137, 120, 110
    MOVE G6A,107,  85, 137,  93,  96
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO RX_EXIT
    ENDIF


    SPEED 11

    MOVE G6D,90, 90, 120, 105, 110
    MOVE G6A,112,  76, 146,  93, 96
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    ERX 4800,A, ��������_����_2
    IF A <> A_old THEN
��������_����_1_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6A, 108,  76, 146,  93,  96		
        MOVE G6D,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB �⺻�ڼ�2
        GOTO RX_EXIT
    ENDIF
    '**********

��������_����_2:
    ETX 4800,12 '�����ڵ带 ����
    SPEED ����ӵ�
    MOVE G6A,112,  76, 146, 93,  96
    MOVE G6D,90, 98, 146,  69, 110
    WAIT


    SPEED �¿�ӵ�
    MOVE G6A, 90,  60, 137, 120, 110
    MOVE G6D,107  85, 137,  93,  96
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO RX_EXIT
    ENDIF


    SPEED 11
    MOVE G6A,90, 90, 120, 105, 110
    MOVE G6D,110,  76, 146,  93,  96
    MOVE G6B, 90
    MOVE G6C,110
    WAIT


    ERX 4800,A, ��������_����_1
    IF A <> A_old THEN
��������_����_2_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6D, 106,  76, 146,  93,  96		
        MOVE G6A,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB �⺻�ڼ�2
        GOTO RX_EXIT
    ENDIF  	

    GOTO ��������_����_1
    '******************************************
������������_����:
    GOSUB All_motor_mode3
    ����COUNT = 0
    SPEED 6
    HIGHSPEED SETON

    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6D,106,  76, 147,  93, 98
    MOVE G6B,90
    MOVE G6C,100
    WAIT
    DELAY 10
    GOTO ������������_����_1

    '**********************

������������_����_1:
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


������������_����_2:

    MOVE G6A,104,   73, 140, 103,  100
    MOVE G6D, 97,  83, 146,  85, 102
    WAIT
    DELAY 10

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0

        GOTO RX_EXIT
    ENDIF

    ' ����COUNT = ����COUNT + 1
    'IF ����COUNT > ����Ƚ�� THEN  GOTO ������������_����_2_stop

    ERX 4800,A, ������������_����_4
    IF A <> A_old THEN
������������_����_2_stop:
        MOVE G6D,93,  90, 125, 95, 104
        MOVE G6A,107,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ����ȭ�ڼ�
        SPEED 5
        GOSUB �⺻�ڼ�2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

������������_����_4:	
    MOVE G6D,93,  74, 140, 100, 106
    MOVE G6A,109,  78, 146,  92,  100
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    DELAY 5

������������_����_5:
    MOVE G6D,101,  74, 140, 103,  100
    MOVE G6A, 97,  85, 144,  87, 102
    WAIT
    DELAY 5

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO RX_EXIT
    ENDIF

    ERX 4800,A, ������������_����_1
    IF A <> A_old THEN
������������_����_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ����ȭ�ڼ�
        SPEED 5
        GOSUB �⺻�ڼ�2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*************************************

    GOTO ������������_����_1
    '**********************
gofoward_LL2:
    GOSUB All_motor_mode3
    'GOSUB Leg_motor_mode3
    SPEED 8
    'HIGHSPEED SETON

    '�����߷� �����߽�

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

    '������������_����_1: �޹ߵ��

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


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0

        GOTO RX_EXIT
    ENDIF

    GOSUB �⺻�ڼ�2

    RETURN
    '**********************
gofoward_LL3:
    GOSUB All_motor_mode3
    'GOSUB Leg_motor_mode3
    '�����߷� �����߽�

    SPEED 5
    '������ ���Խ���
    MOVE G6A,  97,  74, 145, 100, 103,
    MOVE G6D, 103,  79, 135, 104, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT
    '������ �����߽� + �޹� ��¦���
    MOVE G6A,  89,  79, 135, 100, 111,
    MOVE G6D, 110,  77, 146,  93,  99,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  32,  81,  ,  ,
    WAIT
    SPEED 4
    '������ �����߽� + ������ ������ ������ �޹߰��� ����
    MOVE G6A,  86,  75, 141,  96, 111,
    MOVE G6D, 112,  87, 136,  95,  99,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  32,  81,  ,  ,
    WAIT

    SPEED 5
    '������ ����  ��� + �޹� �Ϻ� ����
    MOVE G6A,  98,  73, 138, 106, 101,
    MOVE G6D, 102,  78, 139,  99, 101,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 115,  33,  82,  ,  ,
    WAIT


    DELAY 200
    '�ѹ� ����� �ϼ�
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
    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0

        GOTO RX_EXIT
    ENDIF

    'SPEED 5
    GOSUB �⺻�ڼ�2
    RETURN
    '**********************
gofoward_LL4:
    GOSUB All_motor_mode3
    'GOSUB Leg_motor_mode3
    '�����߷� �����߽�

    SPEED 3
    '������ �����߽�
    MOVE G6A,  94,  74, 145, 100, 101,
    MOVE G6D, 106,  79, 135, 104, 100,
    MOVE G6B, 85,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT
    '������ �����߽� + �޹� ���
    SPEED 5
    MOVE G6A,  88,  78, 141,  93, 111,
    MOVE G6D, 112,  78, 146,  93,  99,
    MOVE G6B,  75,  40,  81,  ,  ,
    MOVE G6C, 105,  32,  81,  ,  ,
    WAIT

    SPEED 3
    '�����߽� �߾� + �޹� �����ϼ�
    MOVE G6A,  98,  71, 138, 112, 102,
    MOVE G6D, 102,  78, 139, 104, 101,
    MOVE G6B,  80,  30,  81,  ,  ,
    MOVE G6C, 110,  33,  82,  ,  ,
    WAIT

    DELAY 95
    '�޹� ����� + �����߽� �޹�
    MOVE G6A, 112,  75, 138, 110, 101,
    MOVE G6D,  90,  76, 139, 104, 106,
    MOVE G6B,  90,  30,  81,  ,  ,
    MOVE G6C, 105,  33,  82,  ,  ,
    WAIT

    SPEED 5
    '�޹� ���� ������ + ������ ������ �������(���ϼ���)
    MOVE G6A, 114,  95, 114, 112,  99,
    MOVE G6D,  83,  95, 113, 109, 113,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0

        GOTO RX_EXIT
    ENDIF

    SPEED 3
    GOSUB �⺻�ڼ�2
    RETURN


    '**********************
gofoward_LL1:
    GOSUB All_motor_mode3
    SPEED 12
    'HIGHSPEED SETON

    '�����߷� �����߽�
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


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0

        GOTO RX_EXIT
    ENDIF

    GOSUB �⺻�ڼ�2


    RETURN
    '**********************
gofoward_L1:
    GOSUB All_motor_mode3
    SPEED 7
    'HIGHSPEED SETON

    '�����߷� �����߽�
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


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0

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
    GOSUB �⺻�ڼ�2

    RETURN

    '******************************************
    '******************************************
������������_����:
    GOSUB All_motor_mode3
    �Ѿ���Ȯ�� = 0
    ����COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  76, 145,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ������������_����_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  76, 145,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ������������_����_4
    ENDIF


    '**********************
goback_L1:
    GOSUB All_motor_mode3
    SPEED 7
    'HIGHSPEED SETON

    '�����߷� �����߽�
    MOVE G6A,95,  76, 145,  93, 105
    MOVE G6D,108,  76, 145,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    '������������_����_1: �޹ߵ��
    MOVE G6D,110,  76, 147,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    '������������_����_3: �޹߳����� ������ ��¦��
    MOVE G6A, 103,  79, 147,  89, 100
    MOVE G6D,100,   65, 147, 103,  102
    WAIT

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO RX_EXIT
    ENDIF

    '������������_����_3_stop:�����ߵ�� ���ڼ�
    MOVE G6D,95,  85, 130, 100, 104
    MOVE G6A,104,  77, 146,  93,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT

    'SPEED 15
    GOSUB ����ȭ�ڼ�
    'HIGHSPEED SETOFF
    SPEED 5
    GOSUB �⺻�ڼ�2

    RETURN
    '**********************
goback_L2:
    GOSUB All_motor_mode3
    SPEED 5
    'HIGHSPEED SETON

    '�����߷� �����߽�
    MOVE G6A,95,  76, 145,  93, 102
    MOVE G6D,106,  76, 145,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    '������������_����_1: �޹ߵ��
    MOVE G6D,111,  77, 147,  93,  102
    MOVE G6A,95,  96, 120, 95, 104
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    SPEED 4
    '������������_����_3: �޹߳����� ������ ��¦��
    MOVE G6A, 95,  92, 129,  92, 102
    MOVE G6D, 105,  85, 123, 105,  99
    WAIT

    MOVE G6A, 105,  90, 128,  97,  96,
    MOVE G6D,  95,  84, 120, 111, 106,
    WAIT



    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
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

������������_����_1:
    MOVE G6D,104,  76, 147,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6B,115
    MOVE G6C,85
    WAIT



������������_����_3:
    MOVE G6A, 103,  79, 147,  89, 100
    MOVE G6D,95,   65, 147, 103,  102
    WAIT

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO RX_EXIT
    ENDIF
    ' ����COUNT = ����COUNT + 1
    ' IF ����COUNT > ����Ƚ�� THEN  GOTO ������������_����_3_stop

    ERX 4800,A, ������������_����_4
    IF A <> A_old THEN
������������_����_3_stop:
        MOVE G6D,95,  85, 130, 100, 104
        MOVE G6A,104,  77, 146,  93,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT

        'SPEED 15
        GOSUB ����ȭ�ڼ�
        HIGHSPEED SETOFF
        SPEED 5
        GOSUB �⺻�ڼ�2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF
    '*********************************

������������_����_4:
    MOVE G6A,104,  76, 147,  93,  102
    MOVE G6D,95,  95, 120, 95, 104
    MOVE G6C,115
    MOVE G6B,85
    WAIT


������������_����_6:
    MOVE G6D, 103,  79, 147,  89, 100
    MOVE G6A,95,   65, 147, 103,  102
    WAIT
    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO RX_EXIT
    ENDIF

    ' ����COUNT = ����COUNT + 1
    'IF ����COUNT > ����Ƚ�� THEN  GOTO ������������_����_6_stop

    ERX 4800,A, ������������_����_1
    IF A <> A_old THEN  'GOTO ������������_����
������������_����_6_stop:
        MOVE G6A,95,  85, 130, 100, 104
        MOVE G6D,104,  77, 146,  93,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT

        'SPEED 15
        GOSUB ����ȭ�ڼ�
        HIGHSPEED SETOFF
        SPEED 5
        GOSUB �⺻�ڼ�2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    GOTO ������������_����_1

    '******************************************
�����ʱ˵�10_����:
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
�����ʱ˵�20_����:
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
�����ʱ˵�30_����:
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
�����ʱ˵�40_����:
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
�����ʱ˵�50_����:
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
�����ʱ˵�60_����:
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
�����ʱ˵�70_����:
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
�����ʱ˵�80_����:
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
�����ʱ˵�90_����:
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
�����ʱ˵�100_����:
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
CCW_����:
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
CW_����:
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

CCW_ȸ��3:
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
CCW_ȸ��4:
    GOSUB All_motor_mode3
    'GOSUB ���̷�OFF

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

    'GOSUB ���̷�ON

    GOTO RX_EXIT
    '******************************************
CCW_ȸ��5:
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
CW_ȸ��5:
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
CCW_ȸ��6:
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
CCW_ȸ��7:
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
CW_ȸ��7:
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
CCW_ȸ��8:
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
CW_ȸ��3:
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
�������:
    PRINT "VOLUME 200 !"
    PRINT "SOUND 44 !" '�ȳ��ϼ���

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
�����ʿ�����10_����: '�����ǵ��� 2 cm
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
    GOSUB �⺻�ڼ�2

    GOTO RX_EXIT

    '************************************************
�����ʿ�����20_����: '�����ʿ����� 3.5cm~3.8cm�̵�
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
    GOSUB �⺻�ڼ�2

    GOTO RX_EXIT
    '************************************************

���ʿ�����20_����: '****
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
    GOSUB �⺻�ڼ�2

    GOTO RX_EXIT

    '**********************************************
���ʿ�����10_����: '****
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
    GOSUB �⺻�ڼ�2

    GOTO RX_EXIT
    '**********************************************
���ʿ�����10_����_2: '****
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
�����ʿ�����10_����_2: '****
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
�����ʿ�����70����_����:
    MOTORMODE G6A,3,3,2,3,2
    MOTORMODE G6D,3,3,2,3,2

�����ʿ�����70����_����_loop:
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
    GOSUB �⺻�ڼ�2

    GOTO RX_EXIT
    '**********************************************

���ʿ�����70����_����:
    MOTORMODE G6A,3,3,2,3,2
    MOTORMODE G6D,3,3,2,3,2
���ʿ�����70����_����_loop:
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
    GOSUB �⺻�ڼ�2

    GOTO RX_EXIT

    '**********************************************
    '************************************************
    '*********************************************

������3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
������3_LOOP:

    IF ������� = 0 THEN
        ������� = 1
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
        ������� = 0
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
    GOSUB �⺻�ڼ�2


    GOTO RX_EXIT

    '**********************************************
��������3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

��������3_LOOP:

    IF ������� = 0 THEN
        ������� = 1
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
        ������� = 0
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
    GOSUB �⺻�ڼ�2

    GOTO RX_EXIT

    '******************************************************
    '**********************************************
������5_����:
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

    GOSUB �⺻�ڼ�2
    GOTO RX_EXIT
    '**********************************************
��������5_����:
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

    GOSUB �⺻�ڼ�2

    GOTO RX_EXIT
    '**********************************************

    '**********************************************
������10_����:
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

    GOSUB �⺻�ڼ�2
    GOTO RX_EXIT
    '**********************************************
��������10_����:
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

    GOSUB �⺻�ڼ�2

    GOTO RX_EXIT
    '**********************************************
    '**********************************************
������20_����:
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

    GOSUB �⺻�ڼ�2

    GOTO RX_EXIT
    '**********************************************
��������20_����:
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

    GOSUB �⺻�ڼ�2

    GOTO RX_EXIT
    '**********************************************

    '**********************************************	


    '**********************************************
������45_����:
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
    GOSUB �⺻�ڼ�2

    '
    GOTO RX_EXIT

    '**********************************************
��������45_����:
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
    GOSUB �⺻�ڼ�2

    GOTO RX_EXIT
    '**********************************************
������60_����:
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
    GOSUB �⺻�ڼ�2

    GOTO RX_EXIT

    '**********************************************
��������60_����:
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
    GOSUB �⺻�ڼ�2

    GOTO RX_EXIT
    '****************************************

�ڷ��Ͼ��:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON		

    GOSUB ���̷�OFF

    GOSUB All_motor_Reset

    SPEED 15
    GOSUB �⺻�ڼ�

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
    GOSUB �⺻�ڼ�3

    �Ѿ���Ȯ�� = 1

    DELAY 200
    GOSUB ���̷�ON
    GOTO RX_EXIT


    RETURN


    '**********************************************
�������Ͼ��:


    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB ���̷�OFF

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
    GOSUB �⺻�ڼ�3
    �Ѿ���Ȯ�� = 1
    '******************************
    DELAY 200
    GOSUB ���̷�ON
    GOSUB GOSUB_RX_EXIT

    RETURN

    '******************************************

�Ӹ�����30��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,70
    GOTO RX_EXIT

�Ӹ�����45��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,55
    GOTO RX_EXIT

�Ӹ�����60��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,40
    GOTO RX_EXIT

�Ӹ�����90��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,10
    GOTO RX_EXIT

�Ӹ�������30��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,130
    GOTO RX_EXIT

�Ӹ�������45��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,145
    GOTO RX_EXIT	

�Ӹ�������60��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,160
    GOTO RX_EXIT

�Ӹ�������90��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,190
    GOTO RX_EXIT

�Ӹ��¿��߾�:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,100
    GOTO RX_EXIT

�Ӹ���������:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,100	
    SPEED 5
    GOSUB �⺻�ڼ�
    GOTO RX_EXIT

�������100��:
    SPEED 3
    S11 = MOTORIN(11)
    S16 = MOTORIN(16)
    S16 = S16 - 5
    SERVO 11, S11
    SERVO 16, S16	

    ETX 4800,23
    GOTO RX_EXIT
    '******************************************

�������۰�100:
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
��������80��:

    SPEED 3
    SERVO 16, 80
    SERVO 11, 100
    ETX 4800,35
    GOTO RX_EXIT
    '******************************************
��������60��:

    SPEED 3
    SERVO 16, 65
    SERVO 11, 100
    ETX 4800,36
    GOTO RX_EXIT
    '******************************************
����35��:

    SPEED 3
    SERVO 16, 35
    SERVO 11, 100
    ETX 4800,40
    GOTO RX_EXIT
    '******************************************
����40��:

    SPEED 3
    SERVO 16, 40
    SERVO 11, 100
    ETX 4800,41
    GOTO RX_EXIT
    '******************************************
����45��:

    SPEED 3
    SERVO 16, 45
    SERVO 11, 100
    ETX 4800,42
    GOTO RX_EXIT
    '******************************************
����50��:

    SPEED 3
    SERVO 16, 50
    SERVO 11, 100
    ETX 4800,43
    GOTO RX_EXIT
    '******************************************
����55��:

    SPEED 3
    SERVO 16, 55
    SERVO 11, 100
    ETX 4800,44
    GOTO RX_EXIT
    '******************************************
����60��:

    SPEED 3
    SERVO 16, 60
    SERVO 11, 100
    ETX 4800,45
    GOTO RX_EXIT
    '******************************************
����65��:

    SPEED 3
    SERVO 16, 65
    SERVO 11, 100
    ETX 4800,46
    GOTO RX_EXIT
    '******************************************
����70��:

    SPEED 3
    SERVO 16, 70
    SERVO 11, 100
    ETX 4800,47
    GOTO RX_EXIT
    '******************************************
����75��:

    SPEED 3
    SERVO 16, 75
    SERVO 11, 100
    ETX 4800,48
    GOTO RX_EXIT
    '******************************************
����80��:

    SPEED 3
    SERVO 16, 80
    SERVO 11, 100
    ETX 4800,49
    GOTO RX_EXIT

    '******************************************
����85��:

    SPEED 3
    SERVO 16, 85
    SERVO 11, 100
    ETX 4800,50
    GOTO RX_EXIT
    '******************************************
����90��:

    SPEED 3
    SERVO 16, 90
    SERVO 11, 100
    ETX 4800,51
    GOTO RX_EXIT
    '******************************************
����95��:

    SPEED 3
    SERVO 16, 95
    SERVO 11, 100
    ETX 4800,52
    GOTO RX_EXIT
    '******************************************
����100��:

    SPEED 3
    SERVO 16, 100
    SERVO 11, 100
    ETX 4800,53
    GOTO RX_EXIT

    '******************************************
    '******************************************
�յڱ�������:
    FOR i = 0 TO COUNT_MAX
        A = AD(�յڱ���AD��Ʈ)	'���� �յ�
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY ����Ȯ�νð�
    NEXT i

    IF A < MIN THEN
        GOSUB �����
    ELSEIF A > MAX THEN
        GOSUB �����
    ENDIF

    RETURN
    '**************************************************
�����:
    A = AD(�յڱ���AD��Ʈ)
    'IF A < MIN THEN GOSUB �������Ͼ��
    IF A < MIN THEN
        ETX  4800,16
        GOSUB �ڷ��Ͼ��
        ETX  4800,38
    ENDIF
    RETURN

�����:
    A = AD(�յڱ���AD��Ʈ)
    'IF A > MAX THEN GOSUB �ڷ��Ͼ��
    IF A > MAX THEN
        ETX  4800,15
        GOSUB �������Ͼ��
        ETX  4800,38
    ENDIF
    RETURN
    '**************************************************
�¿��������:
    FOR i = 0 TO COUNT_MAX
        B = AD(�¿����AD��Ʈ)	'���� �¿�
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY ����Ȯ�νð�
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB �⺻�ڼ�	
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
Number_Play: '  BUTTON_NO = ���ڴ���


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
���ܼ��Ÿ�����Ȯ��:

    ���ܼ��Ÿ��� = AD(���ܼ�AD��Ʈ)

    IF ���ܼ��Ÿ��� > 50 THEN '50 = ���ܼ��Ÿ��� = 25cm
        MUSIC "C"
        DELAY 200
    ENDIF


    RETURN

    '******************************************
������_���������:

    J = AD(���ܼ�AD��Ʈ)	'���ܼ��Ÿ��� �б�
    BUTTON_NO = J
    'GOSUB Number_Play
    'GOSUB SOUND_PLAY_CHK
    GOSUB GOSUB_RX_EXIT


    RETURN

    '************************************************
����_��������_��1:

    CONST ����ä���� = 135

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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '************************************************
����_��������_��2:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '******************************************
    '************************************************
����_��������_��3:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '************************************************
����_��������_��4:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '************************************************
����_��������_��5:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '************************************************
����_��������_��6:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '************************************************
����_��������_��6_1:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '************************************************
����_��������_��6_2:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '************************************************
����_��������_��6_3:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '************************************************
����_��������_��6_4:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '************************************************
����_��������_��6_5:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '************************************************
����_��������_��7:

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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '************************************************
����_��������_��8:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '************************************************
����_��������_��8_3:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN


    '************************************************
����_��������_��8_4:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN

    '************************************************
����_��������_��8_5:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN

    '************************************************
����_��������_��9:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '************************************************
����_��������_��10:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '************************************************
����_��������_��11:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '************************************************
����_��������_��12:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '************************************************
����_��������_��13:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '************************************************
����_��������_��14:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '************************************************
����_��������_��15:


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

    '**** ���� _��������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN

    '************************************************

����_��������_��巹��1:
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
����_����������_��1:
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


    '**** ���� _����������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN


    RETURN
    '************************************************
����_����������_��2:
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


    '**** ���� _����������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '************************************************
����_����������_��3:
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


    '**** ���� _����������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '************************************************
����_����������_��4:
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


    '**** ���� _����������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN

    '******************************************
    '************************************************
����_����������_��5:
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


    '**** ���� _����������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '******************************************
����_����������_��6:
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


    '**** ���� _����������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
    '******************************************
����_����������_��7:
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


    '**** ���� _����������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
 '******************************************
����_����������_��8:
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


    '**** ���� _����������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
'******************************************
����_����������_��9:
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


    '**** ���� _����������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
'******************************************
����_����������_��10:
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


    '**** ���� _����������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
'******************************************
����_����������_��11:
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


    '**** ���� _����������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN

'******************************************
����_����������_��12:
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


    '**** ���� _����������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN
'******************************************
����_����������_��13:
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


    '**** ���� _����������_�� ���ǵ� *******
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

    GOSUB �⺻�ڼ�


    RETURN

    '******************************************

�����þ�Ȯ��1:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 65
    ETX 4800,89
    GOTO RX_EXIT


    '******************************************
�����þ�Ȯ��2:
    GOSUB All_motor_mode3

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,10,  30,  80, 190
    ETX 4800,90
    GOTO RX_EXIT

    '******************************************


����_����������_��巹��1:
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
MAIN: '�󺧼���

    ETX 4800, 38 ' ���� ���� Ȯ�� �۽� ��

MAIN_2:

    GOSUB �յڱ�������
    GOSUB �¿��������
    'GOSUB ���ܼ��Ÿ�����Ȯ��


    ERX 4800,A,MAIN_2	

    A_old = A

    '**** �Էµ� A���� 0 �̸� MAIN �󺧷� ����
    '**** 1�̸� KEY1 ��, 2�̸� key2��... ���¹�
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
        GOSUB �⺻�ڼ�

    ENDIF


    GOTO MAIN	
    '*******************************************
    '		MAIN �󺧷� ����
    '*******************************************

KEY1:
    ETX  4800,1
    GOTO ������5_����
    'GOSUB ����_����������_��6
    GOTO RX_EXIT
    '***************	
KEY2:
    ETX  4800,2

    GOSUB ����_����������_��3

    GOTO RX_EXIT
    '***************
KEY3:
    ETX  4800,3

    GOTO ��������5_����
    'GOSUB gofoward_LL4

    GOTO RX_EXIT
    '***************
KEY4:
    ETX  4800,4

    GOTO ������10_����
    'GOTO ���ʿ�����10_����

    GOTO RX_EXIT
    '***************
KEY5:
    ETX  4800,5

    GOSUB gofoward_H2

    GOTO RX_EXIT
    '***************
KEY6:
    ETX  4800,6

    GOTO ��������10_����


    GOTO RX_EXIT
    '***************
KEY7:
    ETX  4800,7
    GOTO ������20_����

    GOTO RX_EXIT
    '***************
    'KEY8:
    'ETX  4800, 8
    'GOTO

    'GOTO RX_EXIT
    '***************
KEY9:
    ETX  4800,9
    GOTO ��������20_����


    GOTO RX_EXIT
    '***************
KEY10: '0
    ETX  4800,10
    GOTO ������������_����

    GOTO RX_EXIT
    '***************
KEY11: ' ��
    ETX  4800,11

    GOTO ��������_����

    GOTO RX_EXIT
    '***************
KEY12: ' ��
    ETX  4800,12
    GOTO ��������_����

    GOTO RX_EXIT
    '***************
KEY13: '��
    ETX  4800,13
    GOTO �����ʿ�����70����_����


    GOTO RX_EXIT
    '***************
KEY14: ' ��
    ETX  4800,14
    GOTO ���ʿ�����70����_����


    GOTO RX_EXIT
    '***************
KEY15: ' A
    ETX  4800,15
    GOTO ���ʿ�����20_����


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
    GOSUB �����ڼ�	
    GOSUB ������

    GOSUB MOTOR_GET
    GOSUB MOTOR_OFF


    GOSUB GOSUB_RX_EXIT
KEY16_1:

    IF ����ONOFF = 1  THEN
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


    IF  A = 16 THEN 	'�ٽ� �Ŀ���ư�� �����߸� ����
        GOSUB MOTOR_ON
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT

        GOSUB �⺻�ڼ�2
        GOSUB ���̷�ON
        GOSUB All_motor_mode3
        GOTO RX_EXIT
    ENDIF

    GOSUB GOSUB_RX_EXIT
    GOTO KEY16_1



    GOTO RX_EXIT
    '***************
KEY17: ' C
    ETX  4800,17
    GOTO �Ӹ�����90��


    GOTO RX_EXIT
    '***************
KEY18: ' E
    ETX  4800,18	


    GOSUB ���̷�OFF
    GOSUB ������
KEY18_wait:

    ERX 4800,A,KEY18_wait	

    IF  A = 26 THEN
        GOSUB ������
        GOSUB ���̷�ON
        GOTO RX_EXIT
    ENDIF

    GOTO KEY18_wait


    GOTO RX_EXIT
    '***************
KEY19: ' P2
    ETX  4800,19
    GOTO ��������60_����

    GOTO RX_EXIT
    '***************
KEY20: ' B	
    ETX  4800,20
    GOTO �����ʿ�����20_����


    GOTO RX_EXIT
    '***************
KEY21: ' ��
    ETX  4800,21
    GOTO �Ӹ��¿��߾�

    GOTO RX_EXIT
    '***************
KEY22: ' *	
    ETX  4800,22
    GOTO ������45_����

    GOTO RX_EXIT
    '***************
KEY23: ' G
    ETX  4800,23
    GOSUB ����_��������_��12



    GOTO RX_EXIT
    '***************
KEY24: ' #
    ETX  4800,24
    GOTO ��������45_����

    GOTO RX_EXIT
    '***************
KEY25: ' P1
    ETX  4800,25
    GOTO ������60_����

    GOTO RX_EXIT
    '***************
KEY26: ' ��
    ETX  4800,26

    SPEED 5
    GOSUB �⺻�ڼ�2	
    TEMPO 220
    MUSIC "ff"
    GOSUB �⺻�ڼ�
    GOTO RX_EXIT
    '***************
KEY27: ' D
    ETX  4800,27
    GOTO �Ӹ�������90��


    GOTO RX_EXIT
    '***************
KEY8:
    ETX  4800,8
    GOSUB �������۰�100


    GOTO RX_EXIT
    '***************
KEY28: ' ��
    ETX  4800,28
    GOTO �Ӹ�����45��


    GOTO RX_EXIT
    '***************
KEY29: ' ��
    ETX  4800,29

    GOTO CCW_����

    GOTO RX_EXIT
    '***************
KEY30: ' ��
    ETX  4800,30
    GOTO CCW_ȸ��6

    GOTO RX_EXIT
    '***************
KEY31: ' ��
    ETX  4800,31
    GOTO ��������60��

    GOTO RX_EXIT
    '***************

KEY32: ' F
    ETX  4800,32
    GOTO ������������_����
    GOTO RX_EXIT
    '***************
KEY33: ' �����ʿ�10
    ETX  4800,33
    GOTO �����ʿ�����10_����


    GOTO RX_EXIT
    '***************
KEY34: ' ���ʿ�10
    ETX  4800,34
    GOTO ���ʿ�����10_����_2


    GOTO RX_EXIT
    '***************
KEY35:
    ETX  4800,35


    GOTO ����_�Ѱ���


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
    GOTO ����35��



    GOTO RX_EXIT
    '***************
KEY41: ' G
    ETX  4800,41
    GOTO ����40��

    GOTO RX_EXIT
    '***************
KEY42: ' G
    ETX  4800,42
    GOTO ����45��

    GOTO RX_EXIT
    '***************
KEY43: ' G
    ETX  4800,43
    GOTO ����50��

    GOTO RX_EXIT
    '***************
KEY44: ' G
    ETX  4800,44
    GOTO ����55��

    GOTO RX_EXIT
    '***************
KEY45: ' G
    ETX  4800,45
    GOTO ����60��

    GOTO RX_EXIT
    '***************
KEY46: ' G
    ETX  4800,46
    GOTO ����65��

    GOTO RX_EXIT
    '***************
KEY47: ' G
    ETX  4800,47
    GOTO ����70��

    GOTO RX_EXIT
    '***************
KEY48: ' G
    ETX  4800,48
    GOTO ����75��

    GOTO RX_EXIT
    '***************
KEY49: ' G
    ETX  4800,49
    GOTO ����80��

    GOTO RX_EXIT
    '***************
KEY50: ' G
    ETX  4800,50
    GOTO ����85��

    GOTO RX_EXIT
    '***************
KEY51: ' G
    ETX  4800,51
    GOTO ����90��

    GOTO RX_EXIT
    '***************
KEY52: ' G
    ETX  4800,52
    GOTO ����95��

    GOTO RX_EXIT
    '***************
KEY53: ' G
    ETX  4800,53
    GOTO ����100��

    GOTO RX_EXIT
    '***************
KEY54: ' G
    ETX  4800,54
    GOTO CW_����

    GOTO RX_EXIT
    '***************
KEY55: ' ��
    ETX  4800,55
    GOTO CW_ȸ��3

    GOTO RX_EXIT
    '***************	
KEY56:
    ETX  4800,56


    GOSUB ����_��������_��1


    GOTO RX_EXIT
    '***************	
KEY57:
    ETX  4800,57


    GOSUB ����_��������_��2


    GOTO RX_EXIT
    '***************	
KEY58:
    ETX  4800,58


    GOSUB ����_��������_��3


    GOTO RX_EXIT
    '***************	
KEY59:
    ETX  4800,59


    GOSUB ����_��������_��4


    GOTO RX_EXIT
    '***************	
KEY60:
    ETX  4800,60


    GOSUB ����_��������_��5


    GOTO RX_EXIT
    '***************	
KEY61:
    ETX  4800,61


    GOSUB ����_��������_��6


    GOTO RX_EXIT
    '***************	
KEY62:
    ETX  4800,62


    GOSUB ����_��������_��6_1


    GOTO RX_EXIT
    '***************	
KEY63:
    ETX  4800,63


    GOSUB ����_��������_��6_2


    GOTO RX_EXIT
    '***************	
KEY64:
    ETX  4800,64


    GOSUB ����_��������_��6_3


    GOTO RX_EXIT
    '***************	
KEY65:
    ETX  4800,65


    GOSUB ����_��������_��6_4


    GOTO RX_EXIT
    '***************	
KEY66:
    ETX  4800, 66


    GOSUB ����_��������_��6_5


    GOTO RX_EXIT
    '***************	
KEY67:
    ETX  4800,67


    GOSUB ����_��������_��7


    GOTO RX_EXIT
    '***************	
KEY68:
    ETX  4800,68

    GOSUB ����_��������_��8

    GOTO RX_EXIT
    '***************	
KEY69:
    ETX  4800,69

    GOSUB ����_��������_��8_3


    GOTO RX_EXIT
    '***************	
KEY70:
    ETX  4800,70

    GOSUB ����_��������_��8_4


    GOTO RX_EXIT
    '***************	
KEY71:
    ETX  4800,71

    GOSUB ����_��������_��8_5

    GOTO RX_EXIT
    '***************	
KEY72:
    ETX  4800,72

    GOSUB ����_��������_��9


    GOTO RX_EXIT
    '***************	
KEY73:
    ETX  4800,73

    GOSUB ����_��������_��10


    GOTO RX_EXIT
    '***************	
KEY74:
    ETX  4800,74

    GOSUB ����_��������_��11


    GOTO RX_EXIT
    '***************	
KEY75:
    ETX  4800,75

    GOSUB ����_��������_��12


    GOTO RX_EXIT
    '***************	
KEY76:
    ETX  4800,76

    GOSUB ����_��������_��13


    GOTO RX_EXIT
    '***************	
KEY77:
    ETX  4800,77

    GOSUB ����_��������_��14


    GOTO RX_EXIT
    '***************	
KEY78:
    ETX  4800,78

    GOSUB ����_��������_��15


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

    GOSUB ����_����������_��1


    GOTO RX_EXIT
    '***************	
KEY82:
    ETX  4800,82

    GOSUB ����_����������_��2


    GOTO RX_EXIT
    '***************	
KEY83:
    ETX  4800,83

    GOTO �������


    GOTO RX_EXIT
    '***************
KEY84: ' ��
    ETX  4800,84

    GOTO ������������_����

    GOTO RX_EXIT
    '***************
KEY85: ' ��
    ETX  4800,85

    GOSUB ����_����������_��3

    GOTO RX_EXIT
    '***************
KEY86: ' ��
    ETX  4800,86

    GOTO CCW_ȸ��7

    GOTO RX_EXIT
    '***************
KEY87: ' ��
    ETX  4800,87

    GOTO CW_ȸ��7

    GOTO RX_EXIT
    '***************
KEY88: ' ��
    ETX  4800,88

    GOTO CCW_ȸ��8

    GOTO RX_EXIT
    '***************
KEY89: ' ��
    ETX  4800,89

    GOTO �����þ�Ȯ��1

    GOTO RX_EXIT
    '***************
KEY90: ' ��
    ETX  4800,90

    GOTO �����þ�Ȯ��2

    GOTO RX_EXIT
    '***************
KEY91: ' ��
    ETX  4800,91

    GOSUB ����_����������_��4

    GOTO RX_EXIT
    '***************
KEY92: ' ��
    ETX  4800,92

    GOSUB ����_����������_��5

    GOTO RX_EXIT
    '***************
KEY93: ' ��
    ETX  4800,93

    GOSUB ����_����������_��6

    GOTO RX_EXIT
    '***************
KEY94: ' ��
    ETX  4800,94

    GOSUB ����_����������_��7

    GOTO RX_EXIT
'***************
KEY95: ' ��
    ETX  4800,95

    GOSUB ����_����������_��8

    GOTO RX_EXIT
'***************
KEY96: ' ��
    ETX  4800,96

    GOSUB ����_����������_��9

    GOTO RX_EXIT
'***************
KEY97: ' ��
    ETX  4800,97

    GOSUB ����_����������_��10

    GOTO RX_EXIT
'***************
KEY98: ' ��
    ETX  4800,97

    GOSUB ����_����������_��11

    GOTO RX_EXIT
'***************
KEY99: ' ��
    ETX  4800,97

    GOSUB ����_����������_��12

    GOTO RX_EXIT
'***************
KEY100: ' ��
    ETX  4800,97

    GOSUB ����_����������_��13

    GOTO RX_EXIT

