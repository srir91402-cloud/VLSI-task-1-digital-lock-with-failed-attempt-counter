## 100 MHz Clock
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin [get_ports clk]

## Password input
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {code_in[0]}]
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports {code_in[1]}]
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports {code_in[2]}]
set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports {code_in[3]}]

## Buttons
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports submit]
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports reset]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports relock]

## LEDs
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {failed[0]}]
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS33} [get_ports {failed[1]}]
set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS33} [get_ports unlock]
set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports lockout]

## Bitstream compression
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]