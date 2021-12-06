{
  Project: EE-7 Practical 1
  Platform: Parallax Project USB Board
  Revision: 1.7.855
  Author: Muhammad Nasharuddin
  Date: 28th Nov 2021
  Log:
    Date: Desc
        28 Nov: Switched the Rx and Tx pin, Resolved the motions to mylitekit
}

CON
        commRxPin = 24
        commTxPin = 25
        commBaud = 9600

        commStart = $7A
        commForward = $01
        commReverse = $02
        commLeft = $03
        commRight = $04
        commStopAll = $AA

VAR

  long comm1[128], _Ms_001, cogcomm, rxValue
OBJ
  Comm  : "FullDuplexSerial.spin"

PUB Start (mainMSVal, Motion)

  _Ms_001 := mainMSVal '<-- Store the number of milliseconds.
  Stop  ' <-- Ensures cogIDNum are not accidentally called twice
  cogcomm := cognew(Cum(Motion), @comm1) '<-- Starts function s ensorCore in new core.
  return
PUB Cum(Motion)
  Comm.Start(commRxPin, commTxPin, 0 , commBaud)

  repeat
    rxValue := Comm.Rx
    Comm.Str(String(13, "Loading"))
    if (rxValue == commStart)
      Comm.Str(String(13, "Starting"))
      repeat
        rxValue := Comm.Rx
        'Comm.Str(String(13, "no"))
        case rxValue
          commForward:
              long[Motion] := 1
              Comm.Str(String(13, "Go"))
          commReverse:
              long[Motion] := 2
              Comm.Str(String(13, "Gostan"))
          commLeft:
              long[Motion] := 3
              Comm.Str(String(13, "Kiri"))
          commRight:
              long[Motion] := 4
              Comm.Str(String(13, "Kanan"))
          commStopAll:
              long[Motion] := 5
              Comm.Str(String(13, "STARP"))

PUB Stop

  if comm1
    cogstop (comm1~)

PRI Pause(ms) | t

  t := cnt - 1088 'Precise Counting
  repeat (ms #>0)
    waitcnt(t += _MS_001)