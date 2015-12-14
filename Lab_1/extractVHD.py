# -*- coding: utf-8 -*-
"""
Created on Mon Dec 14 18:35:10 2015

@author: pip

@email:5pipitk@gmail.com
"""

import os
#import
suffix='.vhd'
suffix_2='.vhdl'
context=[]
namelist=[]
midstring="""
--------------------------------------------------------------
 ------------------------------------------------------------
  --                %s
 ------------------------------------------------------------
--------------------------------------------------------------
"""
def main():
    filelist=os.listdir()
    for i in filelist:
        if(i.endswith(suffix)or i.endswith(suffix_2) ):
            namelist.append(i.split('.')[0])
            context.append(midstring%i)
            context.append(open(i).read())
            print(i)

    output_name=input("Please tap output file name of summary VHDL:\n")
    if(not output_name.endswith(suffix)or not output_name.endswith(suffix_2)):
        output_name+=suffix
    if(len(context)>0):

        file_pointer=open(output_name,'w')
        for i in context:
            file_pointer.write(i)
            file_pointer.write('\n')

        file_pointer.close()
        print('Mission Complete!')
    else:
        print('No VHDL code to move')




if (__name__=='__main__'):
    main()