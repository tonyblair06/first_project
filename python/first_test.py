#!/usr/bin/env python
# -*- coding: utf-8 -*-

'my first test script'

__author__ = 'JING ZHONG'

import os
import sys
import time

def delete_comments(file_input, str_file):
    output_str = ''
    mult_lines = file_input.readlines()
    for single_line in mult_lines:
        single_line = single_line.strip('\n')
        print(single_line)	
        single_line = single_line.split('--')[0]	
        single_line = single_line.split('/*')[0]
        print(single_line)	
        output_str = output_str + single_line + '\n'
    #print(output_str)	
    file_output = open(str_file,'w') 
    file_output.writelines(output_str)
    file_output.flush()	 
    file_output.close()
    return 0

##main
if __name__ == "__main__":
    #str_file_in = 'D:/svn/DW-Operation-Doc/99-Others/�ڲ�����/DW-T24-��������/��Ʋ�ƷODS.sql'
    #str_file_out = 'D:/svn/DW-Operation-Doc/99-Others/�ڲ�����/DW-T24-��������/��Ʋ�ƷODS_NEW.sql'
	
    #str_file_in = 'D:/svn/DW-Operation-Doc/99-Others/�ڲ�����/DW-T24-��������/��Ʋ�ƷSTAGE.sql'
    #str_file_out = 'D:/svn/DW-Operation-Doc/99-Others/�ڲ�����/DW-T24-��������/��Ʋ�ƷSTAGE_NEW.sql'
	
    #str_file_in = 'D:/svn/DW-Operation-Doc/99-Others/�ڲ�����/DW-T24-��������/�����ƷSTAGE.sql'
    #str_file_out = 'D:/svn/DW-Operation-Doc/99-Others/�ڲ�����/DW-T24-��������/�����ƷSTAGE_NEW.sql'
	
    str_file_in = 'D:/svn/DW-Operation-Doc/99-Others/�ڲ�����/DW-T24-��������/��ƺ�ԼODS.sql'
    str_file_out = 'D:/svn/DW-Operation-Doc/99-Others/�ڲ�����/DW-T24-��������/��ƺ�ԼODS_NEW.sql'
	
    source_file = open(str_file_in,'r')	
    delete_comments(source_file, str_file_out)
	
    str_file_in = 'D:/svn/DW-Operation-Doc/99-Others/�ڲ�����/DW-T24-��������/��ƺ�ԼSTAGE.sql'
    str_file_out = 'D:/svn/DW-Operation-Doc/99-Others/�ڲ�����/DW-T24-��������/��ƺ�ԼSTAGE_NEW.sql'
	
    source_file = open(str_file_in,'r')	
    delete_comments(source_file, str_file_out)
	
    print("Done!") 
	
	for filename in os.listdir(r'D:\tony'):
		print filename
	
	
	
	
