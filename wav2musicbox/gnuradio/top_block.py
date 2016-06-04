#!/usr/bin/env python
##################################################
# Gnuradio Python Flow Graph
# Title: Top Block
# Generated: Wed May 25 01:13:49 2016
##################################################

from gnuradio import analog
from gnuradio import blocks
from gnuradio import eng_notation
from gnuradio import gr
from gnuradio.eng_option import eng_option
from gnuradio.filter import firdes
from grc_gnuradio import wxgui as grc_wxgui
from optparse import OptionParser
import wx

class top_block(grc_wxgui.top_block_gui):

    def __init__(self):
        grc_wxgui.top_block_gui.__init__(self, title="Top Block")
        _icon_path = "/usr/share/icons/hicolor/32x32/apps/gnuradio-grc.png"
        self.SetIcon(wx.Icon(_icon_path, wx.BITMAP_TYPE_ANY))

        ##################################################
        # Variables
        ##################################################
        self.freq = freq = 400
        self.samp_rate = samp_rate = 32000
        self.fname = fname = str(freq)+".wav"

        ##################################################
        # Blocks
        ##################################################
        self.blocks_wavfile_sink_0 = blocks.wavfile_sink(fname, 1, samp_rate, 8)
        self.analog_sig_source_x_0 = analog.sig_source_f(samp_rate, analog.GR_COS_WAVE, freq, 1, 0)
        (self.analog_sig_source_x_0).set_min_output_buffer(1024)

        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_sig_source_x_0, 0), (self.blocks_wavfile_sink_0, 0))


# QT sink close method reimplementation

    def get_freq(self):
        return self.freq

    def set_freq(self, freq):
        self.freq = freq
        self.set_fname(str(self.freq)+".wav")
        self.analog_sig_source_x_0.set_frequency(self.freq)

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.analog_sig_source_x_0.set_sampling_freq(self.samp_rate)

    def get_fname(self):
        return self.fname

    def set_fname(self, fname):
        self.fname = fname
        self.blocks_wavfile_sink_0.open(self.fname)

if __name__ == '__main__':
    import ctypes
    import os
    if os.name == 'posix':
        try:
            x11 = ctypes.cdll.LoadLibrary('libX11.so')
            x11.XInitThreads()
        except:
            print "Warning: failed to XInitThreads()"
    parser = OptionParser(option_class=eng_option, usage="%prog: [options]")
    (options, args) = parser.parse_args()
    tb = top_block()
    tb.Start(True)
    tb.Wait()

