# Multiple_fpga_login
- Multiple ZCU216 FPGA login and readback from the FPGA.
# If not "sudo" for readback.
  If user doesn't want to use sudo multiple times to readback clock files, then we can give permission to necessary files that are involved in readback. 
  - i2c communication protocol
  - gpio 
  - Make sure you install sshpass in both computers.
# Note: ZCU216 board only communicate using i2c. 
# Note: RFSOC4x2 board can communicate by both i2c and spidev
