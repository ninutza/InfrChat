#ifndef INFRCHAT_H
#define INFRCHAT_H

enum {
  AM_INFRMSG = 168,
  INFRMSG_PER = 1024, // time between transmissions, in ms
  DATASIZE = 30      // size of effective data
};


typedef nx_struct dataMsg {
  nx_uint16_t sourceAddr; // always 0 for infrastructure nodes
  nx_uint8_t dType; //data type (i.e. 1 = weather, 2 = traffic, 3 = worksites)
  nx_uint8_t vNum; //version number
  nx_uint8_t pNum; //packet number
  nx_uint8_t data[DATASIZE]; // data contents
} dataMsg;


#endif
