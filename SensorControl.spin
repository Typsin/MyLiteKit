{
  Project: EE-7 Practical 1
  Platform: Parallax Project USB Board
  Revision: 1.5.555
  Author: Muhammad Nasharuddin
  Date: 15th Nov 2021
  Log:
    Date: Desc
}

CON

        '' [Declare Pins]
        tof1SCL = 0
        tof1SDA = 1
        tof1RST = 14

        tof2SCL = 2
        tof2SDA = 3
        tof2RST = 15
        tofAdd = $29

        ultra1SCL = 6
        ultra1SDA = 7
        'Ultrasonic 2 (Back)
        ultra2SCL = 8
        ultra2SDA = 9
VAR
  long cog1Stack[128], cogIDnum  'Stack space for cog
  long _Ms_001

OBJ
  Term: "FullDuplexSerial.spin"
  Ultra: "EE-7_Ultra_V2.spin"
  ToF[2] : "EE-7_ToF.spin"

PUB Start(mainMSVal, mainTOF1Add, mainTOF2Add, mainUltra1Add, mainUltra2Add)' <--- CAUTION this is not a variable  it is a memory address.

  _Ms_001 := mainMSVal '<-- Store the number of milliseconds.

  Stop  ' <-- Ensures cogIDNum are not accidentally called twice

  cogIDnum := cognew(sensorCore(mainTOF1Add, mainTOF2Add, mainUltra1Add, mainUltra2Add), @cog1Stack) '<-- Starts function s ensorCore in new core.
                                                                                                         ' No +1 since ot starts at Cog zero.
  return
PUB Stop

  if cogIDNum
    cogstop (cogIDNum~)

PUB sensorCore(mainTOF1Add, mainTOF2Add, mainUltra1Add, mainUltra2Add)

  Ultra.Init(ultra1SCL, ultra1SDA, 0) 'Assigning & Init the first element
  Ultra.Init(ultra2SCL, ultra2SDA, 1) 'Assigning & Init the second element
  tofInit ' Perform init for both ToF sensors

  ' Run & get readings
  repeat
    long[mainUltra1Add] := Ultra.readSensor(0)
    long[mainUltra2Add] := Ultra.readSensor(1)
    long[mainTOF1Add]   := ToF[0].GetSingleRange(tofAdd)
    long[mainTOF2Add]   := ToF[1].GetSingleRange(tofAdd)
    Pause(50)

{PUB ReadUltrasonic(SensorNum)

  Ultra.Init(ultra1SCL, ultra1SDA, 0)
  Ultra.Init(ultra2SCL, ultra2SDA, 1)
  result := Ultra.readSensor(SensorNum)
  return result
}
PRI tofInit | i

  ToF[0].Init(tof1SCL, tof1SDA, tof1RST)
  ToF[0].ChipReset(1)
  Pause(50)   '1000
  ToF[0].FreshReset(tofAdd)
  ToF[0].MandatoryLoad(tofAdd)
  ToF[0].RecommendedLoad(tofAdd)
  ToF[0].FreshReset(tofAdd)

  ToF[1].Init(tof2SCL, tof2SDA, tof2RST)
  ToF[1].ChipReset(1)
  Pause(50)    '1000
  ToF[1].FreshReset(tofAdd)
  ToF[1].MandatoryLoad(tofAdd)
  ToF[1].RecommendedLoad(tofAdd)
  ToF[1].FreshReset(tofAdd)

  return
PRI Pause(ms) | t

  t := cnt - 1088 'Precise Counting
  repeat (ms #>0)
    waitcnt(t += _MS_001)
  return