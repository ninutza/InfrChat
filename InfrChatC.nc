
#include <Timer.h> 
#include "InfrChatC.h"

// #define LOGGER_ON

module InfrChatC {
  uses {
    interface Boot;
    interface AMSend as SendInfrMsg;
    interface Packet;
    interface SplitControl as AMControl; 
    interface Timer<TMilli> as InfrTimer;
    interface Leds;
  }
}

implementation {
  message_t InfrPkt;
  bool radio_busy;

  event void Boot.booted() {

    // upon booting, start radio
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {

    if (err == SUCCESS) {	// radio successfully initiated, start timer

      call InfrTimer.startOneShot(INFRMSG_PER); 
      dbg("InfrChat","Started infrastructure timer in Dead Zone Quiescent Mode\n");

    }
    else {
      call AMControl.start();
    }

  }

  event void AMControl.stopDone(error_t err) {}

  event void InfrTimer.fired()
  {
    dataMsg *pInfrMsg = (dataMsg*)(call Packet.getPayload(&InfrPkt,(uint8_t)NULL));

    dbg("InfrChat","Timer went off, sending infrastructure message sequence\n"); 
    call Leds.led2On();

    // here, copy real data into infrastructure message content ***
    pInfrMsg->vNum = 1;  
    pInfrMsg->sourceAddr = 0;
    pInfrMsg->dType = 2;
    pInfrMsg->pNum = 1;

    // send first data packet with source ID = 0 (infrastructure)
    if(call SendInfrMsg.send(AM_BROADCAST_ADDR,&InfrPkt,sizeof(dataMsg))==FAIL){ 
    dbg("InfrErr","Sending Failed\n");
    }
    else { }
  }

  event void SendInfrMsg.sendDone(message_t* msg, error_t error) {
     // here, call send repeatedly until all data held by infrastructure node is transmitted
     call Leds.led2Off();
     dbg("InfrChat", "Sending complete, starting timer again\n");
     call InfrTimer.startOneShot(INFRMSG_PER); 
  }


}
