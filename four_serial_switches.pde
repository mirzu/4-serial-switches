#include <Messenger.h>
#include <Bounce.h>

int ledPin1 = 2; // Set the pin to digital I/O 4
int ledPin2 = 3;
int ledPin3 = 4; 
int ledPin4 = 5;
int button1 = 8;
int button2 = 9;
int button3 = 10;
int button4 = 11;
int ledPin13 = 13; // 
Bounce bouncer1 = Bounce( button1,5 ); 
Bounce bouncer2 = Bounce( button2,5 ); 
Bounce bouncer3 = Bounce( button3,5 );  
Bounce bouncer4 = Bounce( button4,5 );  

// Instantiate Messenger object with the default separator (the space character)
Messenger message = Messenger(); 

long lastDebounceTime = 0;  // the last time the output pin was toggled
long debounceDelay = 150;    // the debounce time; increase if the output flickers

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
  message.attach(messageReady);
}
 
void loop() {
  bouncer1.update();
  bouncer2.update();
  bouncer3.update();
  bouncer4.update();
  //digitalWrite(ledPin1, bouncer1.read());
  //digitalWrite(ledPin2, bouncer2.read());
  //digitalWrite(ledPin3, bouncer3.read());
  //digitalWrite(ledPin4, bouncer4.read());
  
  while ( Serial.available())  message.process(Serial.read() );
}
 
void messageReady() {
  int i = 0;
  int pins[4] = {2, 3, 4, 5};
  int values[4]; 
  
  while ( message.available() ) {
    digitalWrite( pins[i], message.readInt() );
    i = i + 1;
  }
}
