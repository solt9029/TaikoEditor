
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(0, OUTPUT);
  pinMode(1, OUTPUT);
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);
  digitalWrite(0, HIGH);
  digitalWrite(1, HIGH);
  digitalWrite(2, HIGH);
  digitalWrite(3, HIGH);
  digitalWrite(4, HIGH);
  digitalWrite(5, HIGH);
  digitalWrite(6, HIGH);
  digitalWrite(7, HIGH);
}

void loop() {
  // put your main code here, to run repeatedly:
  int data0 = analogRead(A0);
  int data1 = analogRead(A1);
  int data2 = analogRead(A2);
  int data3=analogRead(A3);
  int data4=analogRead(A4);
  int data5=analogRead(A5);
  int data10=analogRead(A10);
  int data11=analogRead(A11);
  Serial.print('H');
  Serial.print(data0);
  Serial.print(",");
  Serial.print(data1);
  Serial.print(",");
  Serial.print(data2);
  Serial.print(",");
  Serial.print(data3);
  Serial.print(",");
  Serial.print(data4);
  Serial.print(",");
  Serial.print(data5);
  Serial.print(",");
  Serial.print(data10);
  Serial.print(",");
  Serial.println(data11);
  delay(100);
  

}
