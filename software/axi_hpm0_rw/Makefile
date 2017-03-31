TARGET = axi_hpm0_rw
CFLAGS = -g -Wall
LDFLAGS =  -g -Wall  
CC = $(CROSS_COMPILE)gcc


build: $(TARGET)
$(TARGET): main.o
	$(CC) $(LDFLAGS)   $^ -o $@  
%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f $(TARGET) *.a *.o *~ 
