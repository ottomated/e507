# Parts

## Power
- USB-C port: GT-USB-7010ASV (C2988369)
	- 5.1k resistors on CC1/CC2 to GND

- ESD protection: TVS diode: SMAJ5.0A (C83329)

- battery - 1000+mAh LiPo, with JST PH connector
	- buy separately

- battery connector: S2B-PH-SM4-TB (C295747)
	- 90 degree mount, see if works with case
	- cheaper clone: XY-S2B-PH-SM4-TB (C54582899)

- Buck-boost converter: TPS631000DRLR
	- Converts battery / usb voltage to 3.3V
	- drives esp32, screen, microsd

- LDO: TPS73633DBVT? (C28038)
	- (can only step voltage down)
	- Converts the 5V USB to 3.3V
	- Drives only DAC because low noise compared to buck-boost

- battery charger: BQ25185 (C19725033)
	- Integrated power path
	- Config: RILIM/VSET 18kΩ = 4.2V + 500mA input limit; ISET 600Ω = 500mA charge current (rescale to battery C-rate); no NTC → 10kΩ from TS/MR to GND
	- Can use STAT1 and STAT2 to detect charging status

- Load switch for SD card & audio: AO3401A (C15127)

USB-C -> TVS diode -> BQ25185 -> VSYS

VSYS -> buck-boost -> ESP32, OLED
VSYS -> LDO -> DAC, SD (because SD has high standby usage, LDO can be toggled)
VSYS -> AMP

### How much power are we using?
- esp32, 3.3v — 42–56mA @80MHz, 66–108mA @240MHz (dual core, no RF, modem-sleep)
- screen — OLED, est. 5–25mA (pick part first)
- dac 3.3v — ~20–30mA playing, ~1mA idle
- amp 2.3-5v (can use 3.3) — 2.1mA idle + music
- Total playing ≈ 100–180mA @3.3V → 1000–1500mAh cell ≈ 6–15h

## MCU

- ESP32-S3-WROOM-1U-N16R8 (C3013946)
	- If no space, MINI-1U-N4R2
	- Not STM32 because less examples
	- Requirements: mp3, flac, wav + drive screen
	- No wifi or bluetooth needed at all
	- Needs to get battery charge level
		- ADC voltage divider from BAT+ (e.g. 2×100k) into GPIO
- Microsd reader: DM3CS-SF (C393941)
	- Not accessible without disassembly
	- No card-detect pin
	- hinged for stability
	- load switch to disable in sleep mode?
- Boot / reset buttons: TS-1088-AR02016 (C720477)
	- Not accessible from outside, used for programming

## Interface
- OLED screen
	- Monochrome, ~ 1x0.3in, 128x32px
	- I2C communication
- Power button: TL3340AF160QG (C2886925)
	- right-angle
- Volume up / down: TL3340AF160QG (C2886925)
	- right-angle
- Play button & back button: TS-1088-AR02016 (C720477)
	- More tactile button option: TL3301AF260QG (C273496)

- Spring-loaded rotary switch for navigating tracks (only goes a few degrees each way, spring returns to center)

## Audio

- dac: PCM5102A (C107671)
	- This converts the binary stream of samples from the ESP32 into analog signals
- AMP: TPA6132A2 (C69901)
	- Can't drive the headphones directly off the DAC or something
	- Amp gets power directly from battery (it can handle voltage range)
- 3.5mm jack: SJ-3523-SMT-TR (C4991872)
	- TODO - find a better one maybe?
	- ESD protection?

## Case
- 2 layer: cnc polycarbonate outside, metallic finish 3d print inside
- pcbway does polycarb CNC, ~$60
- maybe try to get bent sheet metal? cheap


## To Copy
https://github.com/Seesternn/-ESP32-S3-MP3-Player - vibecoded, weird?
https://redlib.catsarch.com/r/PrintedCircuitBoard/comments/1wu4k6i/review_request_esp32s3_based_mp3_player BQXXX
https://redlib.catsarch.com/r/PrintedCircuitBoard/comments/1weyspl/schematic_only_review_request_mp3_player_using/ pretty similar
https://www.amazon.com/dp/B0DNW32Y46 PCM5102A DAC example

## References

### BQ25185 / power architecture
- https://www.adafruit.com/product/6092 - Adafruit production board on BQ25185: power path, USB-C + 5.1k CC resistors, JST-PH battery port, status LEDs; called "a great upgrade from MCP7383x-class (TP4056) chargers"
- https://github.com/adafruit/Adafruit-bq25185-with-3.3V-Buck-PCB - Adafruit BQ25185 board design files
- https://e2e.ti.com/support/power-management-group/power-management/f/power-management-forum/1423323/bq25185-help-with-general-schematic-design-and-the-sys-connection - TI official guidance: BQ25185 SYS → 3.3V LDO VIN, STAT1/2 may float (open-drain), ±1% resistor on ISET, 25V-rated caps on IN/SYS
- https://redlib.catsarch.com/r/PrintedCircuitBoard/comments/1s1igb5/review_request_charging_board_using_the_bq25185/ - hobby BQ25185 board with TVS diode on USB-C
- https://redlib.catsarch.com/r/PrintedCircuitBoard/comments/1n0g9er/schematic_review_power_path_with_lipo_charging/ - power path design discussion using BQ25185

### PCM5102A → TPA6132A2 chain
- https://philippraven.com/blog/esp/esp32-music-player-2/ - real-world build report: MAX4410 amp failed with PCM5102A's hot 2.1Vrms output; "a better fit is something like the TPA6132. It handles proper DAC output levels, drives headphones cleanly"; DAC can't drive headphones directly
- https://redlib.catsarch.com/r/PrintedCircuitBoard/comments/1r4i4b7/review_request_headphones_module_for_esp32c3/ - reviewed + approved chain: ESP32 → PCM5102A → TPA6132 → 3.5mm TRRS
- https://www.diyaudio.com/community/threads/connecting-headphone-amp-ic-into-dac-ic-doubts.399341/ - PCM5102A (ground-centered out) → TPA613x input coupling discussion
- https://learn.lonelybinary.com/tinkerblock/blocks/i2s-dac - PCM5102A reference card: 3-wire I2S, no MCLK (internal PLL), XSMT 10k pull-up, 2.1Vrms, 3.3V only (max 3.9V)

### ESP32-S3-WROOM N16R8 (PSRAM)
- https://github.com/Seesternn/-ESP32-S3-MP3-Player (above) - "without 8 MB OPI PSRAM the audio library will crash or stutter"; 16MB flash for 3MB app partition

### Battery gauge options
- https://redlib.catsarch.com/r/PrintedCircuitBoard/comments/1u61evo/review_request_esp32s3_devboard_and_mp3_player/ - MAX17048G fuel gauge used for battery %
- https://github.com/Seesternn/-ESP32-S3-MP3-Player (above) - INA226 for current + runtime estimates; plain voltage-divider SoC is ±10%

### Other ESP32/S3 player builds (reference designs)
- https://redlib.catsarch.com/r/PrintedCircuitBoard/comments/1ht7ujj/review_request_esp32_based_music_player/ - ESP32 + PCM5102A + TP4056 + SD reader
- https://redlib.catsarch.com/r/PrintedCircuitBoard/comments/16qef7l/first_board_esp32_s3_mp3_player_in_need_of/ - ESP32-S3 + MAX98357A (speaker class-D)
- https://redlib.catsarch.com/r/PrintedCircuitBoard/comments/1eakf7j/schematic_review_request_esp32s3_based_audio/ - ESP32-S3 player; comment notes S3 has no Bluetooth audio (classic ESP32 only)
- https://redlib.catsarch.com/r/PrintedCircuitBoard/comments/1vunjtu/review_request_mp34_player/ - MP3/4 player schematic review thread
