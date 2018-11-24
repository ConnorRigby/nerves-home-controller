/*
 * The MySensors Arduino library handles the wireless radio link and protocol
 * between your home built sensors/actuators and HA controller of choice.
 * The sensors forms a self healing radio network with optional repeaters. Each
 * repeater and gateway builds a routing tables in EEPROM which keeps track of the
 * network topology allowing messages to be routed to nodes.
 *
 * Created by Henrik Ekblad <henrik.ekblad@mysensors.org>
 * Copyright (C) 2013-2018 Sensnology AB
 * Full contributor list: https://github.com/mysensors/MySensors/graphs/contributors
 *
 * Documentation: http://www.mysensors.org
 * Support Forum: http://forum.mysensors.org
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * version 2 as published by the Free Software Foundation.
 *
 *******************************
 *
 * REVISION HISTORY
 * Version 1.0 - Henrik Ekblad
 *
 * DESCRIPTION
 * Example sketch showing how to control physical relays.
 * This example will remember relay state after power failure.
 * http://www.mysensors.org/build/relay
 */


#define MY_DEBUG
#define MY_RADIO_RFM69
#define MY_RFM69_NEW_DRIVER
#define MY_OTA_FIRMWARE_FEATURE
#define MY_REPEATER_FEATURE

// Enable repeater functionality for this node
#define MY_REPEATER_FEATURE

#include <MySensors.h>

#define RELAY_PIN 4  // Arduino Digital I/O pin number for first relay (second on pin+1 etc)
#define NUMBER_OF_RELAYS 2 // Total number of attached relays
#define RELAY_ON 1  // GPIO value to write to turn on attached relay
#define RELAY_OFF 0 // GPIO value to write to turn off attached relay
MyMessage msgs[NUMBER_OF_RELAYS];

void before()
{
    for (int sensor=1, pin=RELAY_PIN; sensor<=NUMBER_OF_RELAYS; sensor++, pin++) {
         msgs[sensor-1] = MyMessage(sensor, V_STATUS);

        // Then set relay pins in output mode
        pinMode(pin, OUTPUT);
        // Set relay to last known state (using eeprom storage)
        digitalWrite(pin, loadState(sensor)?RELAY_ON:RELAY_OFF);
    }
}

void setup()
{

}

void presentation()
{
    // Send the sketch version information to the gateway and Controller
    sendSketchInfo("Relay", "1.0");

    for (int sensor=1, pin=RELAY_PIN; sensor<=NUMBER_OF_RELAYS; sensor++, pin++) {
        // Register all sensors to gw (they will be created as child devices)
        present(sensor, S_BINARY);
    }
}


void loop()
{

}

void receive(const MyMessage &message)
{
    // We only expect one type of message from controller. But we better check anyway.
    if (message.type==V_STATUS) {
        send(msgs[message.sensor-1].set(message.getBool()?RELAY_ON:RELAY_OFF, 1));
        digitalWrite(message.sensor-1+RELAY_PIN, message.getBool()?RELAY_ON:RELAY_OFF);
        saveState(message.sensor, message.getBool());

    }
}
