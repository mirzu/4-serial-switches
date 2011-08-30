#include <Bounce.h>

 // Wiring/Arduino code:
 // Read data from the serial and turn ON or OFF a light depending on the value
 
char val; // Data received from the serial port
int ledPin1 = 2; // Set the pin to digital I/O 4
int ledPin2 = 3;
int ledPin3 = 4; 
int ledPin4 = 5;
int button1 = 8;
int button2 = 9;
int button3 = 10;
int button4 = 12;
int ledPin13 = 13; // 
Bounce bouncer1 = Bounce( button1,5 ); 
Bounce bouncer2 = Bounce( button2,5 ); 
Bounce bouncer3 = Bounce( button3,5 );  
Bounce bouncer4 = Bounce( button4,5 );  

void setup() {
  pinMode(ledPin1, OUTPUT); // Set pin as OUTPUT
  pinMode(ledPin2, OUTPUT); // Set pin as OUTPUT
  pinMode(ledPin3, OUTPUT); // Set pin as OUTPUT
  pinMode(ledPin4, OUTPUT); // Set pin as OUTPUT
  digitalWrite(ledPin1, LOW);
  digitalWrite(ledPin2, LOW);
  digitalWrite(ledPin3, LOW);
  digitalWrite(ledPin4, LOW);
 
 Serial.begin(9600); // Start serial communication at 9600 bps
}
 
void loop() {
  
  bouncer1.update();
  bouncer2.update();
  bouncer3.update();
  bouncer4.update();
  digitalWrite(ledPin1, bouncer1.read());
  digitalWrite(ledPin2, bouncer2.read());
  digitalWrite(ledPin3, bouncer3.read());
  digitalWrite(ledPin4, bouncer4.read());

 if (Serial.available()) { // If data is available to read,
 val = Serial.read(); // read it and store it in val
 
     if (val == 'YY') { 
       digitalWrite(ledPin1, HIGH); // turn the LED on
     } else { 
       digitalWrite(ledPin1, LOW); // turn the LED on
     }
     
     if (val == 'W') { 
       digitalWrite(ledPin2, HIGH); // turn the LED on
     } else { 
       digitalWrite(ledPin2, LOW); // turn the LED on
     }
     
     if (val == 'E') { 
       digitalWrite(ledPin3, HIGH); // turn the LED on
     } else { 
       digitalWrite(ledPin3, LOW); // turn the LED on
     }
     
     if (val == 'R') { 
       digitalWrite(ledPin4, HIGH); // turn the LED on
     } else { 
       digitalWrite(ledPin4, LOW); // turn the LED on
     }
 
  } 
}
 
