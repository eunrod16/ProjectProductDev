import pycurl
from io import BytesIO 
from urllib.parse import urlencode
import json

print("-----------------------------------------------------")
print("------------------- INICIO SCRIPT -------------------")
print("-----------------------------------------------------")

base_url = "localhost:8001"

print("\n")
print("-----------------------------------------------------")
print("----------------- /start/reg POST -------------------")
print("-----------------------------------------------------")
print("\n")

b_obj = BytesIO() 
crl = pycurl.Curl() 

# Set URL value
crl.setopt(crl.URL, base_url + '/stars/reg')

# Write bytes that are utf-8 encoded
crl.setopt(crl.WRITEDATA, b_obj)
crl.setopt(crl.CUSTOMREQUEST, "POST")

data = {
    'Mean.ip': 140.5625,
    'Skewness.ip': -0.699648398,
    'Excess.kurtosis.ip': -0.234571412,
    'std.DMSNR.curve': 19.11042644
    }
pf = urlencode(data)

# Sets request method to POST,
# Content-Type header to application/x-www-form-urlencoded
# and data to send in request body.
crl.setopt(crl.POSTFIELDS, pf)

# Perform a file transfer 
crl.perform() 

# End curl session
crl.close()

# Get the content stored in the BytesIO object (in byte characters) 
get_body = b_obj.getvalue()

# Decode the bytes stored in get_body to HTML and print the result 
print('Output:\n%s' % get_body.decode('utf8')) 

print("\n")
print("-----------------------------------------------------")
print("----------------- /start/class POST -------------------")
print("-----------------------------------------------------")
print("\n")

b_obj = BytesIO() 
crl = pycurl.Curl() 

# Set URL value
crl.setopt(crl.URL, base_url + '/stars/class')

# Write bytes that are utf-8 encoded
crl.setopt(crl.WRITEDATA, b_obj)
crl.setopt(crl.CUSTOMREQUEST, "POST")

data = {
    'Mean.ip': 140.5625,
    'Skewness.ip': -0.699648398,
    'Excess.kurtosis.ip': -0.234571412,
    'std.DMSNR.curve': 19.11042644
    }
pf = urlencode(data)

# Sets request method to POST,
# Content-Type header to application/x-www-form-urlencoded
# and data to send in request body.
crl.setopt(crl.POSTFIELDS, pf)

# Perform a file transfer 
crl.perform() 

# End curl session
crl.close()

# Get the content stored in the BytesIO object (in byte characters) 
get_body = b_obj.getvalue()

# Decode the bytes stored in get_body to HTML and print the result 
print('Output:\n%s' % get_body.decode('utf8')) 


print("\n")
print("-----------------------------------------------------")
print("----------------- /stars POST -------------------")
print("-----------------------------------------------------")
print("\n")

b_obj = BytesIO() 
crl = pycurl.Curl() 

# Set URL value
crl.setopt(crl.URL, base_url + '/stars/')

# Write bytes that are utf-8 encoded
crl.setopt(crl.WRITEDATA, b_obj)
crl.setopt(crl.CUSTOMREQUEST, "POST")

data = {
    'Mean.ip': 140.5625,
    'Skewness.ip': -0.699648398,
    'Excess.kurtosis.ip': -0.234571412,
    'std.DMSNR.curve': 19.11042644
    }
pf = urlencode(data)

# Sets request method to POST,
# Content-Type header to application/x-www-form-urlencoded
# and data to send in request body.
crl.setopt(crl.POSTFIELDS, pf)

# Perform a file transfer 
crl.perform() 

# End curl session
crl.close()

# Get the content stored in the BytesIO object (in byte characters) 
get_body = b_obj.getvalue()

# Decode the bytes stored in get_body to HTML and print the result 
print('Output:\n%s' % get_body.decode('utf8')) 

print("\n")
print("-----------------------------------------------------")
print("----------------- /stars/batch POST -------------------")
print("-----------------------------------------------------")
print("\n")

b_obj = BytesIO() 
crl = pycurl.Curl() 

# Set URL value
crl.setopt(crl.URL, base_url + '/stars/batch')

# Write bytes that are utf-8 encoded
crl.setopt(crl.WRITEDATA, b_obj)
crl.setopt(crl.CUSTOMREQUEST, "POST")

f  = open('entry.json', 'r')
data = f.read()
data = data.rstrip('\r\n').replace(' ','')
data = {
    'data': data
    }
# print(data)
pf = urlencode(data)

# Sets request method to POST,
# Content-Type header to application/x-www-form-urlencoded
# and data to send in request body.
crl.setopt(crl.POSTFIELDS, pf)

# Perform a file transfer 
crl.perform() 

# End curl session
crl.close()

# Get the content stored in the BytesIO object (in byte characters) 
get_body = b_obj.getvalue()

# Decode the bytes stored in get_body to HTML and print the result 
print('Output:\n%s' % get_body.decode('utf8')) 

print("\n")
print("-----------------------------------------------------")
print("-------------- /stars/load_test POST -----------------")
print("-----------------------------------------------------")
print("\n")

b_obj = BytesIO() 
crl = pycurl.Curl() 

# Set URL value
crl.setopt(crl.URL, base_url + '/stars/load_test')

# Write bytes that are utf-8 encoded
crl.setopt(crl.WRITEDATA, b_obj)
crl.setopt(crl.CUSTOMREQUEST, "POST")

f  = open('entry.json', 'r')
data = f.read()
data = data.rstrip('\r\n').replace(' ','')
data = {
    'data_to_test': data
    }
# print(data)
pf = urlencode(data)

# Sets request method to POST,
# Content-Type header to application/x-www-form-urlencoded
# and data to send in request body.
crl.setopt(crl.POSTFIELDS, pf)

# Perform a file transfer 
crl.perform() 

# End curl session
crl.close()

# Get the content stored in the BytesIO object (in byte characters) 
get_body = b_obj.getvalue()

# Decode the bytes stored in get_body to HTML and print the result 
print('Output:\n%s' % get_body.decode('utf8')) 