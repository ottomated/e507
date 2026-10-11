# Parts

## Power
- esd protection (tvs diode?)
- battery
- battery connector
- voltage regulator?
- battery charger
	- TP4056, cheap, examples, simpler
	- BQ25185, modern, configurable (C19725033)
- USB-C port (GT-USB-7010ASV) (C2988369)

### How much power are we using?
- esp32, 3.3v,
- screen
- dac 3.3v, might also need 1.8v
- amp 2.3-5v (can use 3.3)

## MCU

- ESP32-S3-WROOM-1U-N16R8 (C3013946)
	- Maybe ESP32-S3-MINI-1U? I don't think we need the extra flash and memory? plus smaller footprint
	- Not STM32 because less examples
- Microsd reader
- Boot / reset buttons (TS-1088-AR02016) (C720477)
- OLED screen

## Audio

- dac PCM5102A (C107671)
	- This converts the binary stream of samples from the ESP32 into analog signals
- AMP TPA6132A2 (C69901)
	- Can't drive the headphones directly off the DAC or something
- 3.5mm jack

## Case
- 2 layer: cnc polycarbonate outside, metallic finish 3d print inside
- pcbway does polycarb CNC, ~$60
- maybe try to get bent sheet metal? cheap


## To Copy
https://github.com/Seesternn/-ESP32-S3-MP3-Player - vibecoded, weird?
https://redlib.catsarch.com/r/PrintedCircuitBoard/comments/1wu4k6i/review_request_esp32s3_based_mp3_player BQXXX
https://redlib.catsarch.com/r/PrintedCircuitBoard/comments/1weyspl/schematic_only_review_request_mp3_player_using/ pretty similar
https://www.amazon.com/dp/B0DNW32Y46 PCM5102A DAC example
