#/bin/python

import json
from multiprocessing.sharedctypes import Value

#Function to fetch key value based upon provided key
def KeyParser(object, key):
  #json utility to convert string object to dictionary
  DictObject = json.loads(object)
  KeyList = key.split('/')
  #print(KeyList)

  #Getting dictionary based upon key in loop
  for i in range(0,len(KeyList)):
    #Condition to check end of dictionary
    if isinstance(DictObject,dict):
      #Condition to check whether passed keys exist or not
      if KeyList[i] in DictObject.keys():
        DictObject = DictObject[KeyList[i]]
        #print(DictObject)
    else:
      print ("INFO: " + "Key-" + KeyList[i] + ' ' + "doesn't exist in dict object")
  return DictObject

object1 = '{"a":{"b":{"c":{"d":"e"}}}}'
key1 = "a/b/c/"
key2 = "a/b"


if __name__ == '__main__':
  Value = KeyParser(object1, key2)
  print ("Result: " + 'Value corrosponding to passed key-"' +  key2 + '"' + " is - " + str(Value))

