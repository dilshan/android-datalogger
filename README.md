# Sensor framework for Data Logging 

This sensor framework is designed to drive 8 active or/and passive sensors and log it's data into remote Android application. It also have option to activate external device(s) based on specified threshold of sensor data.

This sensor controller is mainly build around Raspberry Pi Model 3 B+ and PIC16F877A MCU. PIC16F877A MCU is used to interface/select sensors and it's built-in 10bit ADC is used to capture the analog signals from sensors.

During the prototype stage following sensors are tested with this system:

- [LM35 precision temperature sensor](www.ti.com/lit/ds/symlink/lm35.pdf)
- [MQ7 Carbon Monoxide gas sensor](https://www.sparkfun.com/datasheets/Sensors/Biometric/MQ-7.pdf)
- Electret Microphone
- [NSL-19M51 LDR](https://docs-emea.rs-online.com/webdocs/001a/0900766b8001a9d6.pdf)
- [HC-SR501 PIR sensor](https://www.mpja.com/download/31227sc.pdf)
- [A3144 Hall effect sensor](https://www.allegromicro.com/~/media/Files/Datasheets/A3141-2-3-4-Datasheet.ashx?la=en&hash=BDFBC7C77BB7B12835643BE0F99A3490376C46BB)

## Software components 

PIC16F877A firmware is developed using MPLAB-XC 8 version 1.48. Raspberry Pi used in this system is loaded with Raspbian Stretch and it's server application is developed using Node.js.

To compile the Android application use Delphi with Embarcadero RAD Studio 10.1 (Berlin) IDE.