from PIL import Image, ImageDraw
from PIL import ImageFilter
import pytesseract
from copy import deepcopy
import cv2
import numpy as np
import os
import imutils


def real_text_boxes(image, xoffset = 0, yoffset = 0, global_draw=None, show_seg=False):
    boxes = pytesseract.image_to_boxes(image, lang='eng', config='--oem 1 --psm 12')
    copy_image = deepcopy(image)
    draw = ImageDraw.Draw(copy_image)
    real_boxes = []
    print(boxes)
    for box in boxes.split('\n'):
        box = box.split(' ')
        if len(box) < 5:
            return
        if global_draw is not None:
            global_draw.rectangle((((int(box[1]) + xoffset, image.height - int(box[2]) + yoffset),
                                    (int(box[3]) + xoffset, image.height - int(box[4]) + yoffset))), outline=(255))
        draw.rectangle((((int(box[1]) + xoffset, image.height - int(box[2]) + yoffset),
                         (int(box[3]) + xoffset, image.height - int(box[4]) + yoffset))), outline=(255))
        real_boxes.append((int(box[1]) + xoffset, image.height - int(box[2]) + yoffset, int(box[3]) + xoffset, image.height - int(box[4]) + yoffset))
    if show_seg:
        copy_image.show()
    del copy_image
    del draw
    return real_boxes


def create_image_crop(image, n, m):
    crops = []
    for i in range(0, n):
        for j in range(0, m):
            crops.append(image.crop((i * source_img.width // n, j * source_img.height // m,
                                    (i + 1) * source_img.width // n, (j + 1) * source_img.height // m)))
    return crops


def transform(p2img):
    image = cv2.imread(p2img)
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    gray = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)[1]
    gray = cv2.medianBlur(gray, 3)
    filename = "{}.png".format(os.getpid())
    cv2.imwrite(filename, gray)
    return filename


source_img = Image.open(transform('card.jpg'))
pytesseract.image_to_string(source_img, lang='eng', config='--oem 1 --psm 12')

crops = create_image_crop(source_img, 1, 2)
mp = {}
for crop_img in crops:
    for box in real_text_boxes(crop_img, show_seg=True):
        img = source_img.crop((0, min(300, 340), source_img.width, max(300, 340)))
        print(pytesseract.image_to_string(img, lang='eng', config='--oem 1 --psm 12'))
        img.show()
        break

source_img.show()
