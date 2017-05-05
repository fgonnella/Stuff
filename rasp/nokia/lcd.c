/*
=================================================================================
 Name        : pcd8544_rpi.c
 Version     : 0.1

 Copyright (C) 2012 by Andre Wussow, 2012, desk@binerry.de

 Description :
     A simple PCD8544 LCD (Nokia3310/5110) for Raspberry Pi for displaying some system informations.
	 Makes use of WiringPI-library of Gordon Henderson (https://projects.drogon.net/raspberry-pi/wiringpi/)

	 Recommended connection (http://www.raspberrypi.org/archives/384):
	 LCD pins      Raspberry Pi
	 LCD1 - GND    P06  - GND
	 LCD2 - VCC    P01 - 3.3V
	 LCD3 - CLK    P11 - GPIO0
	 LCD4 - Din    P12 - GPIO1
	 LCD5 - D/C    P13 - GPIO2
	 LCD6 - CS     P15 - GPIO3
	 LCD7 - RST    P16 - GPIO4
	 LCD8 - LED    P01 - 3.3V 

================================================================================
This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.
================================================================================
 */
#include <wiringPi.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/sysinfo.h>
#include "PCD8544.h"

// pin setup
int _din = 1;
int _sclk = 0;
int _dc = 2;
int _rst = 4;
int _cs = 3;
  
// lcd contrast 
int contrast = 60;
  
int main (void)
{
  // print infos
  printf("Raspberry Pi PCD8544 sysinfo display\n");
  printf("========================================\n");
  
  // check wiringPi setup
  if (wiringPiSetup() == -1)
  {
	printf("wiringPi-Error\n");
    exit(1);
  }
  
  // init and clear lcd
  LCDInit(_sclk, _din, _dc, _cs, _rst, contrast);
  LCDclear();
  
  // show logo
  LCDshowLogo();
  
  delay(2000);
  int i = 0;
  for (;;)
  {
    if (i++==10) {
      //      LCDInit(_sclk, _din, _dc, _cs, _rst, contrast);
      i=0;
    }
    //LCDclear();
    // clear lcd
    LCDclear();
    char line[4][14];
    char title[14];
    char buff[255];
    FILE * f = fopen("lcd.txt","r");
    int j;
    for (j=0;j<4;j++) { 
      fscanf(f, "%s", buff);
      int k =0;
      for (k=0; k<14;k++) line[j][k] = buff[k];
    }
    fclose(f);
    sprintf(title, "PiHome (%d)",i);
    // build screen
    LCDdrawstring(0, 0, title);
    LCDdrawline(0, 10, 83, 10, BLACK);
    for (j=0;j<4;j++) 
      LCDdrawstring(0, 12+j*8, line[j]);
    
    LCDdisplay();	  
    printf(".");
    fflush(stdout);
    delay(1000);
    if (i>10000) i=0;
  }
  
    //for (;;){
  //  printf("LED On\n");
  //  digitalWrite(pin, 1);
  //  delay(250);
  //  printf("LED Off\n");
  //  digitalWrite(pin, 0);
  //  delay(250);
  //}

//	  // get system usage / info
//	  struct sysinfo sys_info;
//	  if(sysinfo(&sys_info) != 0)
//	  {
//		printf("sysinfo-Error\n");
//	  }
//	  
//	  // uptime
//	  char uptimeInfo[15];
//	  unsigned long uptime = sys_info.uptime / 60;
//	  sprintf(uptimeInfo, "Uptime %ld min.", uptime);
//	  
//	  // cpu info
//	  char cpuInfo[10]; 
//	  unsigned long avgCpuLoad = sys_info.loads[0] / 1000;
//	  sprintf(cpuInfo, "CPU %ld%%", avgCpuLoad);
//	  
//	  // ram info
//	  char ramInfo[10]; 
//	  unsigned long totalRam = sys_info.freeram / 1024 / 1024;
//	  sprintf(ramInfo, "RAM %ld MB", totalRam);
//	  


  
  return 0;
}
