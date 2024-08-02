#!/bin/bash
# Define the passwords and IP addresses
INTERMEDIATE_PASSWORD="xxxxxxxxxxx" #The one from where FPGA is controlled host pc
FPGA_PASSWORD="xxxxxxxxxxxx" #The login password of your board
INTERMEDIATE_IP="172.1x.x1.xxx" # IP of your host computer
# Array of FPGA IP addresses
FPGA_IPS=("192.x68.x0.xxx" "192.16x.x0.xxx" ) #Ip of FPGAs

# Use sshpass to SSH into the intermediate computer
sshpass -p "$INTERMEDIATE_PASSWORD" ssh -t -o StrictHostKeyChecking=no bishnu@$INTERMEDIATE_IP << 'EOF'
  echo "Inside intermediate machine"

  # Create the FPGA iteration script
  cat << 'ENDSSH' > /tmp/iterate_fpgas.sh
#!/bin/bash
# Define FPGA password
FPGA_PASSWORD="casper"

# Array of FPGA IP addresses
FPGA_IPS=("192.x68.x0.xxx" "192.16x.x0.xxx")

for FPGA_IP in "${FPGA_IPS[@]}"; do
  echo "Connecting to FPGA at IP: $FPGA_IP"

  # Use sshpass to SSH into the FPGA and run the commands
  sshpass -p "$FPGA_PASSWORD" ssh -t -o StrictHostKeyChecking=no casper@$FPGA_IP << 'ENDSSH_FPGA'
    echo "Inside FPGA at IP: $FPGA_IP"
    cd /home/casper/bin

    # Change permissions for i2c devices
    echo "Changing permissions for i2c devices"
    echo "casper" | sudo -S chmod a+rw /dev/i2c-{0..22}# i2c device you have

    # Change permissions for GPIO export and unexport
    echo "Changing permissions for GPIO export and unexport"
    echo "casper" | sudo -S chmod a+rw /sys/class/gpio/export
    echo "casper" | sudo -S chmod a+rw /sys/class/gpio/unexport

    # Change permissions for specific GPIOs
    echo "Changing permissions for specific GPIOs"
    echo "casper" | sudo -S chmod a+rw /sys/class/gpio/gpio510/direction
    echo "casper" | sudo -S chmod a+rw /sys/class/gpio/gpio510/value
    echo "casper" | sudo -S chmod a+rw /sys/class/gpio/gpio511/direction
    echo "casper" | sudo -S chmod a+rw /sys/class/gpio/gpio511/value

    # Run the alpaca_prg_pll_nolmk program
    echo "Running alpaca_prg_pll_nolmk program"
    ./alpaca_prg_pll_nolmk
ENDSSH_FPGA
done
ENDSSH

  # Make the FPGA iteration script executable
  chmod +x /tmp/iterate_fpgas.sh

  # Execute the FPGA iteration script
  /tmp/iterate_fpgas.sh
EOF

