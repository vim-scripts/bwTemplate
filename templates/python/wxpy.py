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
        ## load resource
        ## self.res_ = wx.XmlResource( GUI_FILENAME )
        ## menu
        ## self.SetMenuBar()
        ## toolbar
        ## self.SetToolBar()
        ## statusbar
        ## self.SetStatusBar()
        ##------ panel
        self.panel_=wx.Panel(self,-1)
        self.sizer_ = wx.BoxSizer( wx.VERTICAL )
        ##------ create your widgets here
        ##------ put stuff into sizer
        ## self.sizer_.Add(your_ctrl,proportion = 1,flag=wx.EXPAND)

        ## apply sizer
        self.panel_.SetSizer(self.sizer_)
        self.panel_.SetAutoLayout(True)
##   }}}

class MyApp(wx.App):    ## {{{
    def OnInit(self):
        ## wx.InitAllImageHandlers()
        self.frame_ = myFrame(None,-1,title='')
        self.frame_.Show(True)
        self.SetTopWindow(self.frame_)
        return True
##   }}}

def main():
    app = MyApp(0)
    app.MainLoop()

if __name__ == "__main__":main()
