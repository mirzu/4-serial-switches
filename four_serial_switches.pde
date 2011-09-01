#include <Messenger.h>
#include <Bounce.h>

int fire1 = 2; // Set the pin to digital I/O 4
int fire2 = 3;
int fire3 = 4; 
int fire4 = 5;
int ledPin13 = 13; 
int button1  = 8;
int button2  = 9;
int button3  = 10;
int button4  = 11;

int masterButton  = 12;
int patternButton1 = 6;
int patternButton2 = 16;
int toggle   = 7;
 
Bounce bouncer1 = Bounce( button1 , 5 ); 
Bounce bouncer2 = Bounce( button2 , 5 ); 
Bounce bouncer3 = Bounce( button3 , 5 );  
Bounce bouncer4 = Bounce( button4 , 5 ); 
Bounce masterBouncer = Bounce( masterButton , 5 );
Bounce patternBouncer1 = Bounce( patternButton1 , 5 );
Bounce patternBouncer2 = Bounce( patternButton2 , 5 );

// Instantiate Messenger object with the default separator (the space character)
Messenger message = Messenger(); 

void setup() {
  pinMode(fire1, OUTPUT); // Set pin as OUTPUT
  pinMode(fire2, OUTPUT); // Set pin as OUTPUT
  pinMode(fire3, OUTPUT); // Set pin as OUTPUT
  pinMode(fire4, OUTPUT); // Set pin as OUTPUT
  pinMode(ledPin13, OUTPUT);
  
  digitalWrite(fire1, LOW);
  digitalWrite(fire2, LOW);
  digitalWrite(fire3, LOW);
  digitalWrite(fire4, LOW);
  
  Serial.begin(9600); // Start serial communication at 9600 bps
  message.attach(messageReady);
}
 
void loop() {
  masterBouncer.update();
  if (masterBouncer.read() == HIGH) {
    digitalWrite(ledPin13, HIGH);
    if (digitalRead(toggle) == HIGH){
      patternBouncer1.update();
      patternBouncer2.update();
      if (patternBouncer1.read() == HIGH){
        playPattern(1);
      } else if (patternBouncer2.read() == HIGH){
        playPattern(2);
      } else {
        bouncer1.update();
        bouncer2.update();
        bouncer3.update();
        bouncer4.update();
        digitalWrite(fire1, bouncer1.read());
        digitalWrite(fire2, bouncer2.read());
        digitalWrite(fire3, bouncer3.read());
        digitalWrite(fire4, bouncer4.read());
      }
    } else {
      while ( Serial.available())  message.process(Serial.read() );
    }
  } else {
    digitalWrite(ledPin13, LOW);
  }
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

void playPattern(int patternNumber) {
  if (patternNumber == 1){
    digitalWrite(fire1, HIGH);
    digitalWrite(fire2, HIGH);
    digitalWrite(fire3, LOW);
    digitalWrite(fire4, LOW);
    delay(1000);
    digitalWrite(fire1, LOW);
    digitalWrite(fire2, LOW);
    digitalWrite(fire3, HIGH);
    digitalWrite(fire4, HIGH);
    delay(1000);
  }
  if (patternNumber == 2){
    digitalWrite(fire1, HIGH);
    digitalWrite(fire2, LOW);
    digitalWrite(fire3, HIGH);
    digitalWrite(fire4, LOW);
    delay(1000);
    digitalWrite(fire1, LOW);
    digitalWrite(fire2, HIGH);
    digitalWrite(fire3, LOW);
    digitalWrite(fire4, HIGH);
    delay(1000);
  }
}
