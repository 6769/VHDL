# -*- coding: utf-8 -*-
"""
Created on Mon Dec 14 18:35:10 2015

@author: pip

@email:5pipitk@gmail.com

@usage:Fast move code toagther.
"""

import os
import time
delay_second=0.7
suffix='.vhd'
suffix_2='.vhdl'
context=[]
namelist=[]
midstring_format="""
--------------------------------------------------------------
 ------------------------------------------------------------
  --                %s
 ------------------------------------------------------------
--------------------------------------------------------------
"""
def main():
    filelist=os.listdir()
    for i in filelist:
        if((i.endswith(suffix)or i.endswith(suffix_2) )and not i.startswith('__')):
            namelist.append(i.split('.')[0])
            context.append(midstring_format%i)
            context.append(open(i).read())
            print(i)


    if(len(context)>0):
        output_name=input("Please tap output file name of summary VHDL:\n")
        if(not output_name.endswith(suffix) and not output_name.endswith(suffix_2)):
            output_name+=suffix
        file_pointer=open(output_name,'w')
        for i in context:
            file_pointer.write(i)
            file_pointer.write('\n')

        file_pointer.close()
        print('Mission Complete!')
    else:
        print('No VHDL code to move')
        time.sleep(delay_second)




if (__name__=='__main__'):
    main()