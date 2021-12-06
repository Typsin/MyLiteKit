{
  Project: EE-7 Practical 1
  Platform: Parallax Project USB Board
  Revision: 1.9.555
  Author: Muhammad Nasharuddin
  Date: 28th Nov 2021
  Log:
    Date: Desc
        15 Nov: Created MyliteKit unable to interact with motorcontrol and sensor control
        20 Nov: Managed to get the sensorcontrol to read both tof and ultra
        21 Nov: Managed to get the MotorControl and CommControl interacting
        25 Nov: Revolved Motor Zeroing/ Revamping code to make it more compacted
        27 Nov: Managed to get the CommControl interact to mylitekit
        28 Nov: Fix The Motion with if else statement
}

CON
         _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

        'Creating a Pause()
        _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
        _ms_001     =_ConClkFreq / 1_000


VAR
  long  mainTOF1Add, mainTOF2Add, mainUltra1Add, mainUltra2Add, Motion

OBJ
  Term   :"FullDuplexSerial.spin"
  Motors :"MotorControl.spin"
  Sensors:"SensorControl.spin"
  Comm   :"CommControl.spin"

PUB Main

  'Pause(2000)
  Sensors.Start(_Ms_001, @mainTOF1Add, @mainTOF2Add, @mainUltra1Add, @mainUltra2Add) '<-- Order of address must match as in function.
  Comm.Start (_Ms_001, @Motion)
  Motors.Start (_Ms_001)
  'Term.Start(31, 30, 0, 115200)
  'Term.Start(24, 25, 0, 9600)

  repeat
    case (Motion)
      1:
        if(mainUltra1Add < 280 OR mainTOF1Add > 200)
          Motors.StopAllMotors
        else
          Motors.Forward
      2:
        if(mainUltra2Add < 280 OR mainTOF2Add > 200)
          Motors.StopAllMotors
        else
          Motors.Reverse
      3:
        if(mainUltra1Add < 300 OR mainTOF1Add > 150 OR mainUltra2Add < 300 OR mainTOF2Add > 150)
          Motors.StopAllMotors
        else
          Motors.TurnLeft
      4:
        if(mainUltra1Add < 300 OR mainTOF1Add > 150 OR mainUltra2Add < 300 OR mainTOF2Add > 150)
          Motors.StopAllMotors
        else
          Motors.TurnRight
      5:
          Motors.StopAllMotors


                                                                                  ' The @ is like a pointer.
  {repeat
    Term.Str(String(13, "Ultrasonic 1 Reading: "))
    Term.Dec(mainUltra1Add)
    Term.Str(String(13, "Ultrasonic 2 Reading: "))
    Term.Dec(mainUltra2Add)
    Term.Str(String(13, "TOF 1 Reading: "))
    Term.Dec(mainTOF1Add)
    Term.Str(String(13, "TOF 2 Reading: "))
    Term.Dec(mainTOF2Add)
    Pause(500) }
   ' Term.Tx(0)
    {Motion := 1
    Term.Str(String(13, "Forward"))
    Pause(500)
    if(mainUltra1Add < 150 OR mainTOF1Add > 200 OR mainUltra2Add < 150 OR mainTOF2Add > 200)
      Motion := 5
      Term.Str(String(13, "Stop1"))
      Pause(1000)
        if(mainUltra1Add < 150 OR mainTOF1Add > 200)
         Motion := 2
         Term.Str(String(13, "Reverse"))
         Pause(2000)
        else
          Motion := 1
          Term.Str(String(13, "Forward"))
          Pause(2000)  }
    {Motion := 1
    Term.Str(String(13, "Forward"))
    Pause(500)
    if(mainUltra1Add < 150 OR mainTOF1Add > 200)
      Motion := 5
      Term.Str(String(13, "Stop1"))
      Pause(500)
      Motion := 2
      Term.Str(String(13, "Reverse"))
      Pause(2000)
      Motion := 5
      Term.Str(String(13, "Stop2"))
      Pause(1000)
    Motion := 2
    Term.Str(String(13, "Forward"))
    Pause(500)
    if(mainUltra2Add < 150 OR mainTOF2Add > 200)
      Motion := 5
      Term.Str(String(13, "Stop1"))
      Pause(500)
      Motion := 1
      Term.Str(String(13, "Forward"))
      Pause(2000)
      Motion := 5
      Term.Str(String(13, "Stop2"))
      Pause(1000)  }
PRI Pause(ms) | t

  t := cnt - 1088 'Precise Counting
  repeat (ms #>0)
    waitcnt(t += _MS_001)
  return
