
The wrapper runs a loop on the Sub CPU that is "pumped" by an update call during INT2. As the access operation runs, it will pause at certain points that will take time to complete. It saves this break point to a pointer, which is the call made during VINT. In this way, the Sub CPU is not blocked by time-consuming, lower-level IO operations.

### Setup
CD-ROM access can only be done with the Sub CPU. You'll likely want to include the access wrapper in your SP code, as it will facilitate loading data to the Main CPU early in the game boot process.

Include `cd_sub_cdrom.s` in your code. (If using C, include `cd_sub_cdrom.h` in the source as well as `cd_sub_cdrom.c` and `cd_sub_cdrom.s` in the module definition.) In your SP init subroutine (called `_usercall0` in the BIOS Manual), prime the access loop by calling the `INIT_ACC_LOOP` macro.

Somewhere in your VINT subroutine (_usercall2), make a call to the `PROCESS_ACC_LOOP` macro to keep the access loop moving. You may want to put this at the end of the subroutine or push the registers before calling as, depending on where it is in the access loop, it may clobber any number of registers.

In the early part of SP main subroutine (_usercall1), you'll want to call CDACC_LOAD_DIR and wait for it to complete. This will load the root directory and cache the file information. There is space allocated for 128 files by default, but this can be adjusted to match your project by changing the size of the `dir_cache` buffer.

At this point, you are ready to load files. The process works by setting a pointer to a filename string in `filename_ptr` and an operation request in `access_op`. You will also need to specify the output buffer wither in the GA_DMAADDR register for DMA operations or by setting a pointer in `file_dest_ptr` for the Sub Direct method. You then check `access_op` in a loop until it returns to an idle state, indicating the operation has completed, then verify the result in `access_op_result` to confirm there were no errors. If the result is good, the data should be ready in your buffer.

The Mega CD supports only the ISO9660 Level 1 standard, meaning that only 8.3 filenames using d-characters are allowed. Please see https://wiki.osdev.org/ISO_9660#String_format for the allowed characters. 
