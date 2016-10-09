from PIL import ImageDraw

def draw_territory(board, intersections, image):
    for i in range(19):
        for j in range(19):
            if board[i][j] == 'b':
                x = intersections[i][j][0]
                y = intersections[i][j][1]

                draw = ImageDraw.Draw(image)
                draw.line((x-10, y-10) + (x+10, y+10), fill=40)
            if board[i][j] == 'w':
                x = intersections[i][j][0]
                y = intersections[i][j][1]

                draw = ImageDraw.Draw(image)
                draw.line((x-10, y-10) + (x+10, y+10), fill=240)

    del draw
    image.save("sgf/heymatt.jpg")
