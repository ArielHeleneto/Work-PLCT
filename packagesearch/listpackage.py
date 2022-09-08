#!/usr/bin/python
# -*- coding: UTF-8 -*-

import logging
import re
import xml.etree.ElementTree as ET
from tqdm import tqdm

tree = ET.parse('./source.xml')
root = tree.getroot()
#f.write(root.tag)
with open('./1.csv', 'w',encoding='UTF8') as f:
    f.write("name,arch,version-ver,version-rel,summary,description,url,group\n")
    for package in tqdm(root.findall('{http://linux.duke.edu/metadata/common}package')):
        x=package.find('./{http://linux.duke.edu/metadata/common}name')
        if not x:
            f.write(x.text+',')
        else:
            f.write(',')
        x=package.find('./{http://linux.duke.edu/metadata/common}arch')
        if not x:
            f.write(x.text+',')
        else:
            f.write(',')
        x=package.find('./{http://linux.duke.edu/metadata/common}version')
        if not x:
            f.write(str(x.attrib['ver'])+',')
            f.write(str(x.attrib['rel'])+',')
        else:
            f.write(',,')
        x=package.find('./{http://linux.duke.edu/metadata/common}summary')
        if not x:
            f.write('"'+str(x.text).replace('\n', '').replace('\r', '') +'"'+',')
        else:
            f.write(',')
        x=package.find('./{http://linux.duke.edu/metadata/common}description')
        if not x:
            f.write('"'+str(x.text).replace('\n', '').replace('\r', '')+'"' +',')
        else:
            f.write(',')
        x=package.find('./{http://linux.duke.edu/metadata/common}url')
        if not x:
            f.write('"'+str(x.text)+'"'+',')
        else:
            f.write(',')
        x=package.find('./{http://linux.duke.edu/metadata/common}format/{http://linux.duke.edu/metadata/rpm}group')
        if not x:
            f.write(x.text)
        else:
            f.write(',')
        f.write('\n')
        x=package.find('./{http://linux.duke.edu/metadata/common}format/{http://linux.duke.edu/metadata/rpm}group')
        if not x:
            f.write(x.text)
        else:
            f.write(',')
        f.write('\n')