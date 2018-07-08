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

#include "sensor-controller.h"

void main(void) {
    unsigned int adcValue = 0x00;    
    unsigned char channelVal = 0x00;
    
    initPeripherals();
    
    __delay_ms(2);
    
    while(1) {
        channelVal = PORTD & 0x07;        
        adcValue = getADCValue(channelVal); 
        PORTB = adcValue;
        PORTC = adcValue >> 8;
        __delay_ms(100);
    }
    
    return;
}

unsigned int getADCValue(unsigned char adcChannel) {
    if(adcChannel > 7) {
        return 0;
    }
    
    ADCON0 &= 0xC5;
    ADCON0 |= adcChannel << 3;
    
    __delay_ms(2);
    GO_nDONE = 1;
    while(GO_nDONE);
    
    return ((ADRESH << 8) + ADRESL);
}

void initPeripherals() {
    PORTC = 0x00;
    TRISC = 0xFC;
    
    PORTD = 0x00;
    TRISD = 0x07;
        
    PORTA = 0x00;
    TRISA = 0xFF;
    
    PORTB = 0x00;  
    TRISB = 0x00;
    
    CMCON = 0x07;   
    ADCON0 = 0x41;
    ADCON1 = 0xC0;
    TRISE = 0x07;
    
    INTCON = 0x00;
}