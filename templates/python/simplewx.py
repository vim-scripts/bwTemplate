"""
FILENAME: @FILENAME@
AUTHOR:   @AUTHOR@
DATE:     @DATE@
@CVS_REVISION@
DESCRIPTION:
"""
import wx

class myFrame(wx.Frame):    ## {{{
    def __init__(self, *args, **kwds):
        wx.Frame.__init__(self, *args, **kwds)
        self.panel_=wx.Panel(self,-1)
        ##------ your widgets
        ##------ put stuff into sizer
        self.sizer_ = wx.BoxSizer( wx.VERTICAL )
        ## self.sizer_.Add(your_ctrl,proportion = 1,flag=wx.EXPAND)

        ## apply sizer
        self.panel_.SetSizer(self.sizer_)
        self.panel_.SetAutoLayout(True)
##   }}}

def main():    ## {{{
    app = wx.PySimpleApp(0)
    frame = myFrame(None,-1,title='')
    frame.Show(True)
    app.SetTopWindow(frame)
    app.MainLoop()
##   }}}

if __name__ == "__main__":main()
