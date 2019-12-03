#define button1 3
#define usTrig 5
#define usEcho 7
#define pot A0

bool b1State = 0;
int usDist = 0;

bool b1StatePrev = 0;
int usDistPrev = 0;

void setup() {
  Serial.begin(115200);
  pinMode(button1, INPUT);
  pinMode(pot, INPUT);
  Serial.println("Init done");
}

void loop() {
  b1State = digitalRead(button1);
  usDist = altUsRead();
  if (!(b1State == b1StatePrev && usDist == usDistPrev)) {
    Serial.println(serialPacket(b1State, usDist));
    b1StatePrev = b1State;
    usDistPrev = usDist;
  }
}

String serialPacket(bool b1, int usDistance) {
  String message = String("S") + String(b1) + usDista(usDistance) + String("E");
  return message;
}

String usDista(int p) {
  String s;
  if (p > 470) {
    p = 470;
  }

  if (p < 10) {
    s = "00" + String(p);
  }
  else if (p < 100) {
    s = "0" + String(p);
  }
  else {
    s = String(p);
  }
  return s;
}

int usRead() {
  digitalWrite(usTrig, LOW);
  delay(5);
  digitalWrite(usTrig, HIGH);
  delay(10);
  digitalWrite(usTrig, LOW);
  int dauer = pulseIn(usEcho, HIGH);
  int s = dauer * 0.03432 / 2;
  if (s > 470 || s < 0) {
    s = 200;
  }
  return s;
}

int altUsRead(){
  return analogRead(A0);
}
