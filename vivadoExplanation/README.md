## This is our findings and the important things we learned about AMD Vivado and how to try and use it with Pynq Z2 FPGA board.

### The board we have:
PYNQ Z2
#### Documentation of it can be found here:
https://pynq.readthedocs.io/
#### User Interface of the board:
![image](https://github.com/user-attachments/assets/4cbb743a-079a-424b-8228-d2718ddd2dd3)

#### General explanation:
This FPGA board has a 2 core ARM processor on it running Ubuntu 22.04 with Jupyter Python kernel on it.

Using the web interface as seen on the previous image, you can upload .bit and .hwh files created through the AMD Vivado software and thus allowing you to run the code in the FPGA inside the board and access the memory addresses via the python interface, which can be found inside this repository as the jupyter file : [runCodeHere.ipynb](https://github.com/Imaster171/16-bit-processor/blob/main/vivadoExplanation/runCodeHere.ipynb)

After uploading the Jupyter file to the interface along with your design's .bit and .hwh file, you can load it into the Pynq Overlay and run the command `overlay?` it will show you all the IP packages and memories you have within you FPGA code.

The given Full AXI slave IP template in AMD Vivado does not show up as an AXI but instead only as memory inside the overlay object created via Python! This is important if you would like to communicate with that.

After getting the addresses of your IP package with its name taken from the ```overlay?``` command, you can run:
```
axi_addr=ol.ip_dict['dual_port_axi_instr_0']['phys_addr']
axi_range=ol.ip_dict['dual_port_axi_instr_0']['addr_range']

from pynq import MMIO
mmio=MMIO(axi_addr,axi_range)
```

This example here uses `dual_port_axi_instr_0` which was a lite AXI slave template of 4K memory template given to us where we tried to just overwrite the read and write to memory logic and replaced it with our processor in between using:
```
    ////initiaizing the processor.v:
    processor riskvProcessor (
        .clk(S_AXI_ACLK),
        .reset(S_AXI_ARESETN),
        .pc(pc),
        .instruction2(instruction),
        .reg_b_data(reg_b),
        .reg_c_data(reg_c),
        .reg_a_data(reg_a),
        .python_instruction(python_instruction)
    );
```
where we initialize our processor with exposed registries and instructions to send commands to it.

Then:
```
		//getting instructions to our processor via python:
                python_instruction <= mem[0][15:0];
		
                // writing registries back out to memory to read via python to make sure it all functions:
		            mem[0][31:16] <= reg_c;
		
                mem[2][31:16] <= reg_a;
                mem[2][15:0] <= reg_b;
```

To write the outputs coming from these pins in order to utilize the Python library.


## What was asked of us:

We were asked to make it so that the memory of this slave AXI is used by our processor and also the Python interface be used by a user to send instructions by a user and use the registry outputs we added previously to check whether the instructions were executed properly via the Python interface.

Unfortunately, we were only able to get 64 bits connected via Python and as the board and the .bit file creation via AMD Vivado is very flaky, we were unable to fully create what was asked of us.

but a theoretically correct implementation would be to have aaccess to all 4K of the memory via the Python interface, and then replace our Processor memory file we created in the main src/ directory with this slave AXI memory and use its storage instead and possibly check if all that is being done by the FPGA is correct by using the Python interface via the ARM chip.
