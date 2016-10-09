import sys, re, numpy, Queue

"""
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
"""

def get_territory(board):
    board = str(board).replace(' ', '').replace('\n', '');
    print (board)
    matrix_board = numpy.chararray((19,19))

    # converts board to a 19x19 matrix
    for i in range(19):
        for j in range(19):
            board_char = str(board)[19 * i + j]
            matrix_board[i][j] = board_char
            if board_char == '.':
                matrix_board[i][j] = 'n'

    q = Queue.Queue()
    # 0 state is no adjacent stones
    # 1 white only adjacent stones
    # 2 black only adjacent stones
    # 3 mixed adjacent stones
    state = 0

    # B black stone
    # W white stone
    # n neutral (unvisited)
    # w white territory
    # b black territory
    # V visited space
    # N neutral (visited)

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
                                if matrix_board[x][y] == 'V':
                                    matrix_board[x][y] = 'N'
                    if state == 1:
                        #mark everything 2 white territory
                        for x in range(19):
                            for y in range(19):
                                if matrix_board[x][y] == 'V':
                                    matrix_board[x][y] = 'w'
                    if state == 2:
                        #mark everything -2 black territory
                        for x in range(19):
                            for y in range(19):
                                if matrix_board[x][y] == 'V':
                                    matrix_board[x][y] = 'b'
                    if state == 3:
                        #mark everything 4 neutral (visited)
                        for x in range(19):
                            for y in range(19):
                                if matrix_board[x][y] == 'V':
                                    matrix_board[x][y] = 'N'
                    break

                (i,j) = q.get()

                # if this is an unvisited space
                if matrix_board[i][j] == 'n':

                    # mark this space as new visited
                    matrix_board[i][j] = 'V'

                    # check to the left
                    if j - 1 >= 0:
                        # if the space to the left is unvisited
                        if matrix_board[i][j-1] == 'n':
                            # add it to the queue
                            q.put((i,j-1))
                        # if it is a black stone
                        elif matrix_board[i][j-1] == 'B':
                            # if there havn't been stones or there have only been black
                            # stones
                            if state == 2 or state == 0:
                                state = 2
                            # if there have been any white stones
                            else:
                                state = 3
                        # if it is a white stone
                        elif matrix_board[i][j-1] == 'W':
                            # if there havn't been stones or there have only bee white
                            # stones
                            if state == 1 or state == 0:
                                state = 1
                            # if there havve been any black stones
                            else:
                                state = 3
                        # if it is a neutral stone
                        elif matrix_board[i][j-1] == 'N':
                            state = 3

                    # check above
                    if i - 1 >= 0:
                        # if the space above is unvisited
                        if matrix_board[i-1][j] == 'n':
                            # add it to the queue
                            q.put((i-1,j))
                        # if it is a black stone
                        elif matrix_board[i-1][j] == 'B':
                            # if there havn't been stones or there have only been black
                            # stones
                            if state == 2 or state == 0:
                                state = 2
                            # if there have been any white stones
                            else:
                                state = 3
                        # if it is a white stone
                        elif matrix_board[i-1][j] == 'W':
                            # if there havn't been stones or there have only bee white
                            # stones
                            if state == 1 or state == 0:
                                state = 1
                            # if there have been any black stones
                            else:
                                state = 3
                        # if it is a neutral stone
                        elif matrix_board[i-1][j] == 'n':
                            state = 3

                    # check to the right
                    if j + 1 <= 18:
                        # if the space to the right is unvisited
                        if matrix_board[i][j+1] == 'n':
                            # add it to the queue
                            q.put((i,j+1))
                        # if it is a black stone
                        elif matrix_board[i][j+1] == 'B':
                            # if there havn't been stones or there have only been black
                            # stones
                            if state == 2 or state == 0:
                                state = 2
                            # if there have been any white stones
                            else:
                                state = 3
                        # if it is a white stone
                        elif matrix_board[i][j+1] == 'W':
                            # if there havn't been stones or there have only bee white
                            # stones
                            if state == 1 or state == 0:
                                state = 1
                            # if there have been any black stones
                            else:
                                state = 3
                        # if it is a neutral stone
                        elif matrix_board[i][j+1] == 'N':
                            state = 3


                    # check below
                    if i + 1 <= 18:
                        # if the space below is unvisited
                        if matrix_board[i+1][j] == 'n':
                            # add it to the queue
                            q.put((i+1,j))
                        # if it is a black stone
                        elif matrix_board[i+1][j] == 'B':
                            # if there havn't been stones or there have only been black
                            # stones
                            if state == 2 or state == 0:
                                state = 2
                            # if there have been any white stones
                            else:
                                state = 3
                        # if it is a white stone
                        elif matrix_board[i+1][j] == 'W':
                            # if there havn't been stones or there have only bee white
                            # stones
                            if state == 1 or state == 0:
                                state = 1
                            # if there have been any black stones
                            else:
                                state = 3
                        # if it is a neutral stone
                        elif matrix_board[i+1][j] == 'N':
                            state = 3

    print ('')
    for i in range(19):
        for j in range(19):
            sys.stdout.write (matrix_board[i][j] + ' ')
        print ('')

    return matrix_board
