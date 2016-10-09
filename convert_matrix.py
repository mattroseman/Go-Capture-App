import re, numpy

sgf = open('ff4_ex.sgf', 'r')

board = numpy.zeros((19,19))

for line in sgf:
    print(line)
    for coordinates in re.findall('\WAW\[\w\w\]|\WW\[\w\w\]', line):
        print (coordinates)
        board[ord(coordinates[-3]) - 97][ord(coordinates[-2]) - 97] = 1
    for coordinates in re.findall('\WAB\[\w\w\]|\W\B\[\w\w\]', line):
        print (coordinates)
        board[ord(coordinates[-3]) - 97][ord(coordinates[-2]) - 97] = -1

print(numpy.matrix(board))
