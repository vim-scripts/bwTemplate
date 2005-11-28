"""
FILENAME: @FILENAME@
AUTHOR:   @AUTHOR@
DATE:     @DATE@
@CVS_REVISION@
DESCRIPTION:
"""
import unittest

class @FILE@TestCase(unittest.TestCase):    ## {{{
    def setUp(self):
        pass
    def tearDown(self):
        pass
    def testOne(self):
        pass
## }}}

def test():    ## {{{
    ## suite=unittest.TestSuite()
    ## suite.addTest()
    suite=unittest.makeSuite(@FILE@TestCase,'test')
    ## run
    runner=unittest.TextTestRunner(verbosity=2)
    runner.run(suite)
##   }}}

if __name__=="__main__":test()
