#include "InfrChatC.h"

configuration InfrChatAppC{ 
}

implementation {
  components MainC;
  components InfrChatC;
  components new TimerMilliC() as InfrTimer;
  components  ActiveMessageC; 
  components new AMSenderC(AM_INFRMSG) as AMSender;
  components LedsC;
  
  InfrChatC -> MainC.Boot;
  InfrChatC.Leds -> LedsC;
  InfrChatC.InfrTimer -> InfrTimer;
  InfrChatC.Packet -> AMSender; 
  InfrChatC.AMControl -> ActiveMessageC;
  InfrChatC.SendInfrMsg -> AMSender.AMSend;

}

