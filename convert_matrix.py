import re, numpy, Queue

sgf = open('test.sgf', 'r')

board = numpy.zeros((19,19))

for line in sgf:
    for coordinates in re.findall('\WAW\[\w\w\]|\WW\[\w\w\]', line):
        print (coordinates)
        board[ord(coordinates[-3]) - 97][ord(coordinates[-2]) - 97] = 1
    for coordinates in re.findall('\WAB\[\w\w\]|\W\B\[\w\w\]', line):
        print (coordinates)
        board[ord(coordinates[-3]) - 97][ord(coordinates[-2]) - 97] = -1

print(numpy.matrix(board))
print('\n\n')

q = Queue.Queue()
# 0 state is no adjacent stones
# 1 white only adjacent stones
# 2 black only adjacent stones
# 3 mixed adjacent stones
state = 0

#-1 black stone
# 1 white stone
# 0 neutral (unvisited)
# 2 white territory
#-2 black territory
# 3 visited space
# 4 neutral (visited)

for a in range(19):
    for b in range(19):
        state = 0
        q.put((a,b))
        while (True):
            if q.empty():
                if state == 0:
                    #mark everything 4 neutral (visited)
                    for x in range(19):
                        for y in range(19):
                            if board[x][y] == 3:
                                board[x][y] = 4
                if state == 1:
                    #mark everything 2 white territory
                    for x in range(19):
                        for y in range(19):
                            if board[x][y] == 3:
                                board[x][y] = 2
                if state == 2:
                    #mark everything -2 black territory
                    for x in range(19):
                        for y in range(19):
                            if board[x][y] == 3:
                                board[x][y] = -2
                if state == 3:
                    #mark everything 4 neutral (visited)
                    for x in range(19):
                        for y in range(19):
                            if board[x][y] == 3:
                                board[x][y] = 4
                break

            (i,j) = q.get()

            # if this is an unvisited space
            if board[i][j] == 0:

                # mark this space as new visited
                board[i][j] = 3

                # check to the left
                if i - 1 >= 0:
                    # if the space to the left is unvisited
                    if board[i-1][j] == 0:
                        # add it to the queue
                        q.put((i-1,j))
                    # if it is a black stone
                    elif board[i-1][j] == -1:
                        # if there havn't been stones or there have only been black
                        # stones
                        if state == 2 or state == 0:
                            state = 2
                        # if there have been any white stones
                        else:
                            state = 3
                    # if it is a white stone
                    elif board[i-1][j] == 1:
                        # if there havn't been stones or there have only bee white
                        # stones
                        if state == 1 or state == 0:
                            state = 1
                        # if there havve been any black stones
                        else:
                            state = 3
                    # if it is a neutral stone
                    elif board[i-1][j] == 4:
                        state = 3

                # check above
                if j - 1 >= 0:
                    # if the space above is unvisited
                    if board[i][j-1] == 0:
                        # add it to the queue
                        q.put((i,j-1))
                    # if it is a black stone
                    elif board[i][j-1] == -1:
                        # if there havn't been stones or there have only been black
                        # stones
                        if state == 2 or state == 0:
                            state = 2
                        # if there have been any white stones
                        else:
                            state = 3
                    # if it is a white stone
                    elif board[i][j-1] == 1:
                        # if there havn't been stones or there have only bee white
                        # stones
                        if state == 1 or state == 0:
                            state = 1
                        # if there have been any black stones
                        else:
                            state = 3
                    # if it is a neutral stone
                    elif board[i-1][j] == 4:
                        state = 3

                # check to the right
                if i + 1 <= 18:
                    # if the space to the right is unvisited
                    if board[i+1][j] == 0:
                        # add it to the queue
                        q.put((i+1,j))
                    # if it is a black stone
                    elif board[i+1][j] == -1:
                        # if there havn't been stones or there have only been black
                        # stones
                        if state == 2 or state == 0:
                            state = 2
                        # if there have been any white stones
                        else:
                            state = 3
                    # if it is a white stone
                    elif board[i+1][j] == 1:
                        # if there havn't been stones or there have only bee white
                        # stones
                        if state == 1 or state == 0:
                            state = 1
                        # if there have been any black stones
                        else:
                            state = 3
                    # if it is a neutral stone
                    elif board[i-1][j] == 4:
                        state = 3


                # check below
                if j + 1 <= 18:
                    # if the space below is unvisited
                    if board[i][j+1] == 0:
                        # add it to the queue
                        q.put((i,j-1))
                    # if it is a black stone
                    elif board[i][j+1] == -1:
                        # if there havn't been stones or there have only been black
                        # stones
                        if state == 2 or state == 0:
                            state = 2
                        # if there have been any white stones
                        else:
                            state = 3
                    # if it is a white stone
                    elif board[i][j+1] == 1:
                        # if there havn't been stones or there have only bee white
                        # stones
                        if state == 1 or state == 0:
                            state = 1
                        # if there have been any black stones
                        else:
                            state = 3
                    # if it is a neutral stone
                    elif board[i-1][j] == 4:
                        state = 3

print(numpy.matrix(board))
