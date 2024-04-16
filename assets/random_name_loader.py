inputFile = open("AlienNames.txt", "r")
lines = inputFile.readlines()
inputFile.close()
outputFile = open("AlienNamesArray.txt", "w")
outputFile.write("[")
for i in range(len(lines)):
    outputFile.write("\"" + lines[i].strip().replace('\"', '\\"') + "\"")
    if i < len(lines) - 1:
        outputFile.write(",\n                 ")
outputFile.write("]")
outputFile.close()