#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <string.h>
#include <unistd.h>
#include <getopt.h>
#include <stdint.h>

#define M_AXI_HPM0_ADDR		0x80000000
#define M_AXI_HPM0_UB_ADDR	0x800FFFFF
#define FPGA_CAST(type, ptr)  				((type) (ptr))
#define fpga_write_word(dest, src)       	(*FPGA_CAST(volatile uint32_t *, (dest)) = (src))
#define fpga_read_word(src)              	(*FPGA_CAST(volatile uint32_t *, (src)))
#define fpga_replbits_word(dest, msk, src)  (fpga_write_word(dest,(fpga_read_word(dest) & ~(msk)) | ((src) & (msk))))

static int fd;
static void *virtual_base;

static int virtual_mmap()
{
	// Map entire AXI GP0 address space
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return(1);
	}
	virtual_base = mmap( NULL, ( M_AXI_HPM0_UB_ADDR - M_AXI_HPM0_ADDR ), ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, M_AXI_HPM0_ADDR );	
	if( virtual_base == MAP_FAILED ) {
		printf("ERROR: mmap() failed...\n");
		close(fd);
		return(1);
	}
	// printf("Virtual Base Address: 0x%x\n", virtual_base);
	return(0);
}

static int virtual_munmap()
{
	// Unmap and close memory 
	if( munmap( virtual_base, ( M_AXI_HPM0_UB_ADDR - M_AXI_HPM0_ADDR ) ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return(1);
	}
	close( fd );
	return(0);
}

static void usage()
{
	printf("Usage: h2flw_rw -r|w <OFFSET> -v <WR_VALE> -m <MASK> \n");
	printf("\t-h this Help\n");
	printf("\t-r|w <OFFSET> (Hex)\n");
	printf("\t-v <WR_VALUE> (Hex)\n");
	printf("\t-m <MASK> (Hex)\n");	
}

int main(int argc, char *argv[])
{
	unsigned int offset, mask, wr_value, rd_value;
	int rw_n, opt, mask_flag, wr_value_flag;
	offset = 0; mask = 0; wr_value = 0; rd_value = 0; rw_n = 0; mask_flag = 0; wr_value_flag = 0;

	// Parse command line arugments
	if ( argc < 2 ) {
		usage();
		return (1);
	} else {
		while ((opt=getopt(argc,argv,"hr:w:m:v:")) != -1) {
			switch(opt) {
			case 'r':
				offset = strtol(optarg, NULL, 16);
				// printf("RD offset: 0x%x\n", offset);
				rw_n = 1;
				break;
			case 'w':
				offset = strtol(optarg, NULL, 16);
				// printf("WR offset: 0x%x\n", offset);
				rw_n = 0;
				break;
			case 'm':
				mask = strtol(optarg, NULL, 16);
				mask_flag = 1;
				// printf("Mask: 0x%x\n", mask);
				break;
			case 'v':
				wr_value = strtol(optarg, NULL, 16);
				wr_value_flag = 1;
				// printf("Write Value: 0x%x\n", wr_value);
				break;			
			case 'h':
			default:
				usage();
				return(1);
			}
		}		
	}	

	// Read
	if ( rw_n == 1 ) {
		virtual_mmap();
		rd_value = fpga_read_word(virtual_base+offset);
		virtual_munmap();
		printf("0x%x\n", rd_value);
	// Write
	} else {
		// Check for write value
		if ( wr_value_flag == 0 ) { 
			usage();
			return(1);
		} else {
		// Unmasked Write
		if ( mask_flag == 0 ) {
			virtual_mmap();
			fpga_write_word(virtual_base+offset, wr_value);
			virtual_munmap();
			// printf("WR Value: 0x%x\n", wr_value);
		// Masked Write
		} else {
			virtual_mmap();
			fpga_replbits_word(virtual_base+offset, mask, wr_value);
			virtual_munmap();
			// printf("WR Value: 0x%x\n", wr_value);
			// printf("Mask:     0x%x\n", mask);
		}
	}}
	return(0);
}