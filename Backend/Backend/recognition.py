from PIL import Image, ImageDraw
from PIL import ImageFilter
import pytesseract
from copy import deepcopy
import cv2
import numpy as np
import os
import imutils
import json
from imutils import contours
import argparse
import sys


def real_text_boxes(image, xoffset = 0, yoffset = 0, global_draw=None, show_seg=False, lang='eng'):
    boxes = pytesseract.image_to_boxes(image, lang=lang, config='')
    copy_image = deepcopy(image)
    draw = ImageDraw.Draw(copy_image)
    real_boxes = []
    for box in boxes.split('\n'):
        box = box.split(' ')
        if len(box) < 5:
            continue
        if global_draw != None:
            global_draw.rectangle((((int(box[1]) + xoffset, image.height - int(box[2]) + yoffset),
                                    (int(box[3]) + xoffset, image.height - int(box[4]) + yoffset))), outline=(255))
        draw.rectangle((((int(box[1]) + xoffset, image.height - int(box[2]) + yoffset),
                         (int(box[3]) + xoffset, image.height - int(box[4]) + yoffset))), outline=(255))
        real_boxes.append((box[0], int(box[1]) + xoffset, image.height - int(box[2]) + yoffset, int(box[3]) + xoffset, image.height - int(box[4]) + yoffset))
    if show_seg:
        copy_image.show()
    del copy_image
    del draw
    return real_boxes


def create_image_crop(image, n, m):
    crops = []
    for i in range(0, n):
        for j in range(0, m):
            crops.append((image.crop((i * image.width // n, j * image.height // m,
                                    (i + 1) * image.width // n, (j + 1) * image.height // m)), i, j))
    return crops


def transform(imagepath):
    image = cv2.imread(imagepath)
    if len(image) > 600 or len(image[0]) > 600:
        image = cv2.resize(image, None, fx=0.4, fy=0.4, interpolation=cv2.INTER_CUBIC)
    filename = "{}.png".format(imagepath.split('.')[0] + "_processed")
    image = cv2.resize(image, None, fx=1.3, fy=1.3, interpolation=cv2.INTER_CUBIC)
    print(np.mean(image), end=" is a ")
    if np.mean(image) < 127: ## BLACK TRANSFORM
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        gray = cv2.GaussianBlur(gray, (5, 5), 0)
        cv2.imwrite(filename, gray)
    else:
        print("Light Image")
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        gray = cv2.bilateralFilter(gray,9,75,75)
        cv2.imwrite(filename, gray)
    return filename



def process_card(imagepath):
    source_img = Image.open(transform(imagepath))
    global_drawer = ImageDraw.Draw(source_img)
    n, m = 1, 3
    crops = create_image_crop(source_img, n, m)
    json_data = {}
    json_data["count"] = 0
    json_data["items"] = []
    dw = source_img.width // n
    dh = source_img.height // m
    ys = set()
    for crop in crops:
        print(pytesseract.image_to_string(crop[0]))
        for box in real_text_boxes(crop[0], xoffset=dw*crop[1], yoffset=dh*crop[2], global_draw=global_drawer):
            arr = {}
            print(box)
            arr["str"] = box[0]
            arr["x1"] = min(box[1], box[3])
            arr["y1"] = min(box[2], box[4])
            arr["x2"] = max(box[1], box[3])
            arr["y2"] = max(box[2], box[4])
            json_data["items"].append(arr)
    file2save = open('d{}.json'.format(imagepath), "w")
    file2save.write(json.dumps(json_data))
    file2save.close()
    source_img.show()


def main():
    for i in range(1, len(sys.argv)):
        process_card(sys.argv[i])
        os.system('./main ' + sys.argv[i] + '.json')


if __name__ == '__main__':
    main()