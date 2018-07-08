//////////////////////////////////////////////////////////////////////////////////////////////
// Sensor framework - (U1) MCU firmware.
//
// Last update: 	04-07-2018 7:21AM.
// Author: 			Dilshan R Jayakody [jayakody2000lk@gmail.com]
// Platform: 		PIC16F877A
//
// Copyright (C) 2018 Dilshan R Jayakody.
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.
//////////////////////////////////////////////////////////////////////////////////////////////

#ifndef SENSOR_CONTROLLER_H
#define	SENSOR_CONTROLLER_H

// CONFIG
#pragma config FOSC = HS  
#pragma config WDTE = OFF 
#pragma config PWRTE = ON 
#pragma config BOREN = OFF
#pragma config LVP = OFF  
#pragma config CPD = OFF  
#pragma config WRT = OFF  
#pragma config CP = OFF   

#include <xc.h>

#define _XTAL_FREQ 8000000

void initPeripherals();
unsigned int getADCValue(unsigned char adcChannel);

#endif	/* SENSOR_CONTROLLER_H */

