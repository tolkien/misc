// to help someone who assemble the kitrone

  #define SW_PWM_P3                  A1        
  #define SW_PWM_P4                  A0
uint8_t PWM_PIN[8] = {9,10,5,6,4,A2,SW_PWM_P3,SW_PWM_P4};   //for a quad+: rear,right,left,front

void setup() {
  // put your setup code here, to run once:
  for(int i=0; i < 4; i++) {
    pinMode(PWM_PIN[i], OUTPUT);
  }
}

void loop() {
  // put your main code here, to run repeatedly:
  uint8_t throttle = 8;

  for(int i=0; i < 4; i++) {
    analogWrite(PWM_PIN[i], throttle);
  }

  delay(1000*1000);
}
