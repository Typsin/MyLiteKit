{
  Project: EE-9 Practical 1
  Platform: Parallax Project USB Board
  Revision: 1.7.555
  Author: Muhammad Nasharuddin
  Date: 28th Nov 2021
  Log:
    Date: Desc
        28 Nov Removed all i to a fix values
}


CON
        '' [Declare Pins for Motor]

        motor1 = 10
        motor2 = 11
        motor3 = 12
        motor4 = 13

        motor1Zero= 1550
        motor2Zero= 1550
        motor3Zero= 1570
        motor4Zero= 1585

        motor1Zero1= 1480
        motor2Zero1= 1525
        motor3Zero1= 1540
        motor4Zero1= 1545

        motor1Zero2= 1665
        motor2Zero2= 1720
        motor3Zero2= 1735
        motor4Zero2= 1740


        gas = 250
        back = 250
VAR
  long  motor[128], cogmotor, _Ms_001

OBJ
  Motors: "servo8Fast_vZ2.spin"
  Terms:  "FullDuplexSerial.spin" 'URAT communication for debugging
'PUB Main |  i,j
  'Init
  'StopCore
  'Pause (4000)
  'Start
  'Init
 { Motors.set(motor1,1545)'1480-1545 '1770-1855
  Motors.set(motor2,1545)'1525-1545 '1460-1745
  Motors.set(motor3,1580)'1540-1580 '1520-1560
  Motors.set(motor4,1585)'1545-1585 '1510-1565  }
  'Reverse(i)

  'Pause(2000)
  {
  repeat j from 0 to 1
    case (j)
      0:
        Forward(i)
      1:
        TurnRight(i)
      2:
        Forward (i)
      3:
        TurnLeft (i)
      4:
        Forward (i)
      5:
        Reverse(i)
      6:
        TurnRight (i)
      7:
        Reverse(i)
      8:
        TurnLeft (i)
      9:
        Reverse (i)

           }
  'StopCore

PUB Start (mainMSVal)

  _Ms_001 := mainMSVal
  Stop  ' <-- Ensures cogIDNum are not accidentally called twice
  cogmotor := cognew(Set, @motor) '<-- Starts function s ensorCore in new core.


  return

PUB Stop

  if cogmotor
    cogstop (cogmotor~)

'PUB Init

  ' Declaration & Initilisation
  {Motors.Init
  Motors.AddSlowPin(motor1)
  Motors.AddSlowPin(motor2)
  Motors.AddSlowPin(motor3)
  Motors.AddSlowPin(motor4)
  Pause(100)}
  {
  Motors.set(motor1,1545)'1480-1545 '1770-1855
  Motors.set(motor2,1500)'1525-1570 '1460-1745
  Motors.set(motor3,1580)'1540-1580 '1520-1560
  Motors.set(motor4,1585)'1545-1585 '1510-1565  }
 { repeat
    repeat i from 0 to 350 step 50 '10%
      Motors.Set(motor1, motor1Zero+i)
      Motors.Set(motor2, motor2Zero+i)
      Motors.Set(motor3, motor3Zero+i)
      Motors.Set(motor4, motor4Zero+i)
      Pause(50)
    Pause(1000)
    repeat i from 350 to 0 step 50 '10%
      Motors.Set(motor1, motor1Zero+i)
      Motors.Set(motor2, motor2Zero+i)
      Motors.Set(motor3, motor3Zero+i)
      Motors.Set(motor4, motor4Zero+i)
      Pause(50)
    Pause(1000)               }
PUB Set

  Motors.Set(motor1, motor1Zero2)
  Motors.Set(motor2, motor2Zero2)
  Motors.Set(motor3, motor3Zero2)
  Motors.Set(motor4, motor4Zero2)

  Motors.Init
  Motors.AddSlowPin(motor1)
  Motors.AddSlowPin(motor2)
  Motors.AddSlowPin(motor3)
  Motors.AddSlowPin(motor4)
  Motors.Start
  'Pause(100)

  {
  repeat
    case long[Motion]
      1:
       Forward
      2:
       Reverse
      3:
       TurnLeft
      4:
       TurnRight
      5:
       StopAllMotors
            }
PUB StopAllMotors

    Motors.Set(motor1, motor1Zero2)
    Motors.Set(motor2, motor2Zero2)
    Motors.Set(motor3, motor3Zero2)
    Motors.Set(motor4, motor4Zero2)
    'Pause(1800)


PUB Forward| i

   'repeat i from 0 to 100 step 10 '10%
    Motors.Set(motor1, motor1Zero2+gas)
    Motors.Set(motor2, motor2Zero2+gas)
    Motors.Set(motor3, motor3Zero2+gas)
    Motors.Set(motor4, motor4Zero2+gas)

  'Pause(1000)
  'StopAllMotors

PUB Reverse| i

    'repeat i from 0 to 250  step 10
     Motors.Set(motor1, motor1Zero2-back)
     Motors.Set(motor2, motor2Zero2-back)
     Motors.Set(motor3, motor3Zero2-back)
     Motors.Set(motor4, motor4Zero2-back)

   'Pause(1000)
   'StopAllMotors

PUB TurnRight| i

    'repeat i from 0 to 100 step 10
     Motors.Set(motor1, motor1Zero2-back)
     Motors.Set(motor2, motor2Zero2+gas)
     Motors.Set(motor3, motor3Zero2-back)
     Motors.Set(motor4, motor4Zero2+gas)

    'Pause(700)
    'StopAllMotors

PUB TurnLeft| i

    'repeat i from 0 to 100 step 10
     Motors.Set(motor1, motor1Zero2+gas)
     Motors.Set(motor2, motor2Zero2-back)
     Motors.Set(motor3, motor3Zero2+gas)
     Motors.Set(motor4, motor4Zero2-back)

    'Pause(600)
    'StopAllMotors



PRI Pause(ms) | t

  t := cnt - 1088 'Precise Counting
  repeat (ms #>0)
    waitcnt(t += _MS_001)
  return