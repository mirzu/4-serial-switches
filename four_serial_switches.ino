#include <CmdMessenger.h>
#include <Bounce.h>
#include <stdlib.h>

// Base64 library available from https://github.com/adamvr/arduino-base64
#include <Base64.h>

// Streaming4 library available from http://arduiniana.org/libraries/streaming/
#include <Streaming.h>
// ------------------ C M D  L I S T I N G ( T X / R X ) ---------------------

// We can define up to a default of 50 cmds total, including both directions (send + recieve)
// and including also the first 4 default command codes for the generic error handling.
// If you run out of message slots, then just increase the value of MAXCALLBACKS in CmdMessenger.h

// Commands we send from the Arduino to be received on the PC
enum
{
  kCOMM_ERROR    = 000, // Lets Arduino report serial port comm error back to the PC (only works for some comm errors)
  kACK           = 001, // Arduino acknowledges cmd was received
  kARDUINO_READY = 002, // After opening the comm port, send this cmd 02 from PC to check arduino is ready
  kERR           = 003, // Arduino reports badly formatted cmd, or cmd not recognised

  // Now we can define many more 'send' commands, coming from the arduino -> the PC, eg
  // kICE_CREAM_READY,
  // kICE_CREAM_PRICE,
  // For the above commands, we just call cmdMessenger.sendCmd() anywhere we want in our Arduino program.

  kSEND_CMDS_END, // Mustnt delete this line
};

int fire1 = 2;
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

// Mustnt conflict / collide with our message payload data. Fine if we use base64 library ^^ above
char field_separator = ',';
char command_separator = ';';

// Attach a new CmdMessenger object to the default Serial port
CmdMessenger cmdMessenger = CmdMessenger(Serial, field_separator, command_separator);

messengerCallbackFunction messengerCallbacks[] = 
{
  serialSwitches,
  NULL
};
// Its also possible (above ^^) to implement some symetric commands, when both the Arduino and
// PC / host are using each other's same command numbers. However we recommend only to do this if you
// really have the exact same messages going in both directions. Then specify the integers (with '=')

// ------------------ C A L L B A C K  M E T H O D S -------------------------

void serialSwitches() {
  int i = 0;
  int pins[4] = {2, 3, 4, 5};
  cmdMessenger.sendCmd(kACK,"Message Recieved");
  while ( cmdMessenger.available() ) {
    Serial.println(i + 1);
    int number = cmdMessenger.readInt();
    digitalWrite( pins[i], number );
    i = i + 1;
  }
}

// ------------------ D E F A U L T  C A L L B A C K S -----------------------

void arduino_ready()
{
  // In response to ping. We just send a throw-away Acknowledgement to say "im alive"
  cmdMessenger.sendCmd(kACK,"Arduino ready");
}

void unknownCmd()
{
  // Default response for unknown commands and corrupt messages
  cmdMessenger.sendCmd(kERR,"Unknown command");
}

// ------------------ E N D  C A L L B A C K  M E T H O D S ------------------


// ------------------  Simple sequencing code. ------------------

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

// ------------------ S E T U P ----------------------------------------------

void attach_callbacks(messengerCallbackFunction* callbacks)
{
  int i = 0;
  int offset = kSEND_CMDS_END;
  while(callbacks[i])
  {
    cmdMessenger.attach(offset+i, callbacks[i]);
    i++;
  }
}

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
  
  // Listen on serial connection for messages from the pc
  // Serial.begin(57600);  // Arduino Duemilanove, FTDI Serial
  Serial.begin(115200); // Arduino Uno, Mega, with AT8u2 USB
  
  // cmdMessenger.discard_LF_CR(); // Useful if your terminal appends CR/LF, and you wish to remove them
  cmdMessenger.print_LF_CR();   // Make output more readable whilst debugging in Arduino Serial Monitor
 
  // Attach default / generic callback methods
  cmdMessenger.attach(kARDUINO_READY, arduino_ready);
  cmdMessenger.attach(unknownCmd);

  // Attach my application's user-defined callback methods
  attach_callbacks(messengerCallbacks);

  arduino_ready();
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
      // Process incoming serial data, if any
      cmdMessenger.feedinSerialData();
    }
  } else {
    digitalWrite(ledPin13, LOW);
  }
}



/* old messenger code.
void messageReady() {
  int i = 0;
  int pins[4] = {2, 3, 4, 5};
  int values[4]; 
  
  while ( message.available() ) {
    digitalWrite( pins[i], message.readInt() );
    i = i + 1;
  }
}
*/

