#!/usr/bin/env python
# -*- coding: utf-8 -*-



import os
import re
import urllib
	  
list_event = ''  
list_no_event_file_name = ''

for filename in os.listdir(r'D:\temp\event'.decode('utf-8')):
    imglist = []
    source_file = open(r'D:\temp\event\\' +filename,'r')	
    mult_lines = source_file.readlines()
    for single_line in mult_lines:
        reg = r'value="(.+?)"'
        imgre = re.compile(reg)
        if re.findall(imgre,single_line) <> []:        
            imglist.append(re.findall(imgre,single_line)[0])      
    if len(imglist) == 0:
        list_no_event_file_name = list_no_event_file_name + filename + '\n'
    else:
        list_event = list_event + '<event event_id="'+imglist[1]+'" event_class="'+imglist[0]+'"/>' + '\n'
        #list_event = list_event + imglist[1] + '\n'

file_output = open(r'D:\temp\event.log','w') 
file_output.writelines(list_no_event_file_name)
file_output.writelines('\n')
file_output.writelines(list_event)
file_output.flush()	 
file_output.close()	
	
	
