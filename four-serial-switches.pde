 // Wiring/Arduino code:
 // Read data from the serial and turn ON or OFF a light depending on the value
 
 char val; // Data received from the serial port
 int ledPin4 = 4; // Set the pin to digital I/O 4
 int ledPin5 = 5;
 int ledPin6 = 6; 
 int ledPin7 = 7;
 
 void setup() {
 pinMode(ledPin4, OUTPUT); // Set pin as OUTPUT
 pinMode(ledPin5, OUTPUT); // Set pin as OUTPUT
 pinMode(ledPin6, OUTPUT); // Set pin as OUTPUT
 pinMode(ledPin7, OUTPUT); // Set pin as OUTPUT
 Serial.begin(9600); // Start serial communication at 9600 bps
 }
 
 void loop() {
 if (Serial.available()) { // If data is available to read,
 val = Serial.read(); // read it and store it in val
 
 //if there is no signal just blinks pin 7
 } else {
   digitalWrite(ledPin7, HIGH);
   delay(500);  
   digitalWrite(ledPin7, LOW);
   delay(500);
 } 
 
 if (val == 'Q') { // If 1-1 was received
   digitalWrite(ledPin4, HIGH); // turn the LED on
 } else { // If 1-1 was received
   digitalWrite(ledPin4, LOW); // turn the LED on
 }
 
 if (val == 'W') { // If 1-1 was received
   digitalWrite(ledPin5, HIGH); // turn the LED on
 } else { // If 1-1 was received
   digitalWrite(ledPin5, LOW); // turn the LED on
 }
 
 if (val == 'E') { // If 1-1 was received
   digitalWrite(ledPin6, HIGH); // turn the LED on
 } else { // If 1-1 was received
   digitalWrite(ledPin6, LOW); // turn the LED on
 }
 
 if (val == 'R') { // If 1-1 was received
   digitalWrite(ledPin7, HIGH); // turn the LED on
 } else { // If 1-1 was received
   digitalWrite(ledPin7, LOW); // turn the LED on
 }
 
 //delay(10); // Wait 100 milliseconds for next reading
 }
 
