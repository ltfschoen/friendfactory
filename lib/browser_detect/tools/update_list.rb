# update the user agent list from 
# 1) http://www.user-agents.org/allagents.xml
# 2) http://user-agent-string.info/rpc/get_data.php?uaslist=csv

# the idea is that we can extend this list if we find new resources.

# using the categories from www.user-agents.org as a reference:
# B = Browser 
# C = Link-, bookmark-, server- checking D = Downloading tool
# P = Proxy server, web filtering
# R = Robot, crawler, spider 
# S = Spam or bad bot
# we are adding M - mobile browser and U=unknown

# final output:
# String, Type, Description, Comment, Link1, Link2

require 'open-uri'
require 'rubygems'
require "nokogiri"


# 1) http://www.user-agents.org/allagents.xml
# format is as follows (example):
# <user-agent>
# <ID>id_t_z_160806_1</ID>
# <String>XMLSlurp/0.1 libwww-perl/5.805</String>
# <Description>GPath / XMLSlurp - Expression language for tree structured data</Description>
# <Type/>
# <Comment/>
# <Link1>http://groovy.codehaus.org/GPath</Link1>
# <Link2/>
# </user-agent>

f = File.open("db.csv", 'w') 


doc=Nokogiri::XML(open('http://www.user-agents.org/allagents.xml'))
a=Array.new
note=doc.search("user-agent")
note.each do |n|
  #a << n.at('Type').inner_text
  
  # if Type is empty or not B,C,D,P,R,S,? - we don't need it.
  txt=n.at('Type').inner_text.split(" ")
  next if txt.size>7
  txt="U" if txt.size==0
  f.write("\"#{n.at('String').inner_text}\",\"#{txt}\",\"#{n.at('Description').inner_text}\",\"#{n.at('Comment').inner_text}\",\"#{n.at('Link1').inner_text}\",\"#{n.at('Link2').inner_text}\"\n") 
end


# 2) http://user-agent-string.info/rpc/get_data.php?uaslist=csv
# string
# type
# comment

f.close