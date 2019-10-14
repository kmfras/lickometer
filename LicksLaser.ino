//This program collects data from the Adafruit MPR121 sensor, writes onto an SD card, and also has the ability to generate an output pulse to control a stimulus generator (e.g a Master9)
//This code was written by Kurt M. Fraser, David H. Ottenheimer, & Tabitha Kim in the Janak Lab.
//The code sd() runs the code to open the logXXXX data file, write the data, clear the dataString to keep the arduino buffer functional, and close the file everytime new data is generated
//dataString is a list of text that includes the milliseconds an event occured and the title of the event. 
//Data in the resulting single .txt file will be listed in the format { YYYY, lickC, ZZZ, lickL, etc.).
//The arduino will generate a new text file everytime it is reset or turned on, but you will not be able to know the name of the text file so IT IS IMPERATIVE THAT THE SD REMOVED AND DATA TRANSFERRED AND RENAMED AFTER EACH SESSION. 
//Last Updated April 17, 2019

#include <SPI.h>
#include <SD.h>
#include <Wire.h>
#include <Adafruit_MPR121.h>

Adafruit_MPR121 cap = Adafruit_MPR121();

// Keeps track of the last electrodes touched
// so we know when licks start and stop
uint16_t lasttouched = 0;
uint16_t currtouched = 0;

int stimPin = {8};
int stimState = LOW;

unsigned long currMillis = {0};
unsigned long prevMillis = {0};


long OnTime = 10;
long OffTime = 990;

String datalogName = "log";
String dataString = "";
char fileName[50];
File myFile;

void setup() 
{
  Serial.begin(9600);
  while (!Serial) 
  {
    ; // wait for serial port to connect. Needed for native USB port only
  }

//Initialize the MPR121 sensor  
    if (!cap.begin(0x5A)) 
  {
    Serial.println("MPR121 not found, check wiring?");
    while (1);
  }
    Serial.println("MPR121 found!");
  
    Serial.print("Initializing SD card...");
    
    pinMode(stimPin, OUTPUT);  // sets digital pin 8 as output for our TTL 
    pinMode(10, OUTPUT);  // sets digital pin 10 as output which is needed for the SD Card shield we are using (SeeedStudios v4.x)
    
//initialize SD card and create a file to write to (on an Arduino the 4 should be 53)
    if(!SD.begin(4))
    {
      Serial.println("card failed, or not present.");
      return;
    }
    else
    { 
      Serial.println("card initialized.");
    }

//Generate a random name for our file by appending a number after Log, convert that string to Characters, and make that our file name in the format LogXXXX.txt.
    randomSeed(analogRead(3));           //the value in analogRead needs to be set to a pin that is NOT in use            
    datalogName += String(random(1000,2000)-random(0,1000));
    datalogName += ".txt";
    datalogName.toCharArray(fileName, 50);
    Serial.println(fileName);

//Create the file with the generated name. This is mainly for debugging.
    Serial.println("Creating data file...");
    myFile = SD.open(fileName, FILE_WRITE);
    myFile.close();

//Check to see if the file exists:
    if (SD.exists(fileName)) {
      Serial.print("File ");
      Serial.print(fileName); 
      Serial.println(" exists.");
    }
    else
    {
      Serial.println("File doesn't exist.");
    }

}

void loop() 
{
  currMillis = millis();
//Get the currently touched sensors (most of this code is directly from the MPR121 test example)
  currtouched = cap.touched();
//if it wasn't touched and now it is

//this should detect if the sensor on 0 was touched and if so initiate recording that event.
  if ((currtouched & _BV(0)) && !(lasttouched & _BV(0))) 
    {
    lickC();
    }

//this should detect if the sensor on 5 was touched and if so initiate recording that event and the laser stimulation pulse.
  if ((currtouched & _BV(5)) && !(lasttouched & _BV(5)))  
    {
    lickL();
    if ((stimState == LOW) && (currMillis - prevMillis >= OffTime)) {
stimState = HIGH;
      prevMillis = currMillis;
      digitalWrite (stimPin, HIGH);
      laser();
   }
    else if ((stimState == HIGH) && (currMillis - prevMillis >= OnTime)) {
      stimState = LOW;
      prevMillis = currMillis;
      digitalWrite (stimPin, LOW);
   }
    }
    
  lasttouched = currtouched;
  
  sd();             
}


void lickC()
//Timestamp the event that was detected on sensor 0
{
  dataString += String(millis());
  dataString += ", lickC, ";
} 

void lickL()
//Timestamp the event that was detected on sensor 5
{
  dataString += String(millis());
  dataString += ", lickL, ";
} 

void laser()
//Timestamp the onset on the pulse, send the pulse, and wait 1s before you are able to send another. (set time of stimulation required here, stimulation parameters are determined by the Master9)
//Simply comment this out if you wish to only record licks absent any stimulation
{
  dataString += String(millis());
  dataString += ", laser, ";
  digitalWrite(8, HIGH);
  delay(10);
  digitalWrite(8, LOW);
} 

void sd()
{
      if (dataString.length()>1)
    //  Serial.println(dataString); //use this for debugging or if you want to send it through the serial port
      {
        File myFile = SD.open(fileName, FILE_WRITE);
        myFile.print(dataString);
        myFile.close();
        //Serial.println(dataString);// use this for debugging or if you want to send it through the serial port
        dataString = "";
    }
}
