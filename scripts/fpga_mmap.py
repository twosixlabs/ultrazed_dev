#!/usr/bin/python

"""
Use python mmap to access FPGA address space - Based on pydevmem github repo

References:
    https://github.com/kylemanna/pydevmem.git
    http://wiki.python.org/moin/PythonSpeed/PerformanceTips
    http://www.python.org/dev/peps/pep-0008/

"""

import os
import sys
import mmap
import struct

# This class holds data for objects returned from DevMem class - It allows an easy way to print hex data
class devmembuffer:

    def __init__(self, base_addr, data):
        self.data = data
        self.base_addr = base_addr

    def __len__(self):
        return len(self.data)

    def __getitem__(self, key):
        return self.data[key]

    def __setitem__(self, key, value):
        self.data[key] = value

    def hexdump(self, word_size = 4, words_per_row = 4):
        # Build a list of strings and then join them in the last step.
        # This is more efficient then concat'ing immutable strings.

        d = self.data
        dump = []

        word = 0
        while (word < len(d)):
            dump.append('0x{0:02x}:  '.format(self.base_addr
                                              + word_size * word))

            max_col = word + words_per_row
            if max_col > len(d): max_col = len(d)

            while (word < max_col):
                # If the word is 4 bytes, then handle it and continue the
                # loop, this should be the normal case
                if word_size == 4:
                    dump.append(" {0:08x} ".format(d[word]))
                    word += 1
                    continue

                # Otherwise the word_size is not an int, pack it so it can be
                # un-packed to the desired word size.  This should blindly
                # handle endian problems (Verify?)
                packed = struct.pack('I',(d[word]))
                if word_size == 2:
                    dh = struct.unpack('HH', packed)
                    dump.append(" {0:04x}".format(dh[0]))
                    word += 1
                elif word_size == 1:
                    db = struct.unpack('BBBB', packed)
                    dump.append(" {0:02x}".format(db[0]))
                    word += 1

            dump.append('\n')

        # Chop off the last new line character and join the list of strings
        # in to a single string
        return ''.join(dump[:-1])

    def __str__(self):
        return self.hexdump()

    def __hex__(self):
        hexdata = self.data
        for i in range(0,len(self.data)):
            hexdata[i] = hex(self.data[i])
        return str(hexdata)

# Read/Write data aligned to word boundaries of /dev/mem
class devmem:
    # Size of a word that will be used for reading/writing
    word = 4
    mask = ~(word - 1)

    def __init__(self, base_addr, length = 1, filename = '/dev/mem',
                 debug = 0):

        if base_addr < 0 or length < 0: raise AssertionError
        self._debug = debug

        self.base_addr = base_addr & ~(mmap.PAGESIZE - 1)
        self.base_addr_offset = base_addr - self.base_addr

        stop = base_addr + length * self.word
        if (stop % self.mask):
            stop = (stop + self.word) & ~(self.word - 1)

        self.length = stop - self.base_addr
        self.fname = filename

        # Check filesize (doesn't work with /dev/mem)
        #filesize = os.stat(self.fname).st_size
        #if (self.base_addr + self.length) > filesize:
        #    self.length = filesize - self.base_addr

        self.debug('init with base_addr = {0} and length = {1} on {2}'.
                format(hex(self.base_addr), hex(self.length), self.fname))

        # Open file and mmap
        self.fd = os.open(self.fname, os.O_RDWR | os.O_SYNC)
        self.mem = mmap.mmap(self.fd, self.length, mmap.MAP_SHARED,
                mmap.PROT_READ | mmap.PROT_WRITE,
                offset=self.base_addr)

    # Make sure we close /dev/mem AND the file descriptor after the read/write is complete
    def __del__(self):
        self.mem.close()
        os.close(self.fd)

    # Read length number of words
    def read(self, length):
        if length < 0: raise AssertionError

        # Make reading easier (and faster... won't resolve dot in loops)
        mem = self.mem

        # Compensate for the base_address not being what the user requested
        # and then seek to the aligned offset.
        virt_base_addr = self.base_addr_offset & self.mask
        mem.seek(virt_base_addr)

        # Read length words of size self.word and return it
        data = []
        for i in range(length):
            data.append(struct.unpack('I', mem.read(self.word))[0])

        abs_addr = self.base_addr + virt_base_addr
        return devmembuffer(abs_addr, data)


    # Write length number of words
    def write(self, din):
        if len(din) <= 0: raise AssertionError

        # Make reading easier (and faster... won't resolve dot in loops)
        mem = self.mem

        # Seek to the aligned offset
        virt_base_addr = self.base_addr_offset & self.mask
        mem.seek(virt_base_addr)

        # Read until the end of our aligned address
        for i in range(0, len(din)):
            self.debug('writing at position = {0}: 0x{1:x}'.
                        format(self.mem.tell(), din[i]))
            # Write one word at a time
            mem.write(struct.pack('I', din[i]))

    def debug_set(self, value):
        self._debug = value

    def debug(self, debug_str):
        if self._debug: print ("DevMem Debug: {0}".format(debug_str))

