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
import main2

from skimage import filters
from skimage.color.adapt_rgb import adapt_rgb, each_channel, hsv_value


@adapt_rgb(each_channel)
def sobel_each(image):
    return filters.sobel(image)


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


def upd2(image):
    h = image.shape[0]
    w = image.shape[1]
    summ = image.mean() + 12
    image2 = np.zeros((h, w))
    for i in range(h):
        for j in range(w):
            if (image[i][j].sum() > summ):
                image2[i][j] = 0
            else:
                image2[i][j] = 255
    return image2


def transform(imagepath):
    image = cv2.imread(imagepath)
    filename = "{}.png".format(imagepath.split('.')[0] + "_processed")
    image = cv2.resize(image, None, fx=0.7, fy = 0.7, interpolation=cv2.INTER_LINEAR)
    print(np.mean(image), end=" is a ")
    if np.mean(image) < 127: ## BLACK TRANSFORM
        print("Dark Image")
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
        for box in real_text_boxes(crop[0], xoffset=dw*crop[1], yoffset=dh*crop[2]):
            arr = {}
            arr["str"] = box[0]
            arr["x1"] = min(box[1], box[3])
            arr["y1"] = min(box[2], box[4])
            arr["x2"] = max(box[1], box[3])
            arr["y2"] = max(box[2], box[4])
            json_data["items"].append(arr)
    file2save = open('{}.json'.format(imagepath), "w")
    file2save.write(json.dumps(json_data))
    file2save.close()
    return (False, '')


def start(filepath):
    process_card(filepath)
    str = os.popen('./main ' + filepath + '.json').read()
    if "pizdec" in str:
        str = str.split('\n')[1]
    str = str.replace("null", '""')
    json_data = json.loads(str)
    if json_data["BankInfo"] == "":
        json_data["BankInfo"] = {}
    return json.dumps(json_data)

if __name__ == '__main__':
    print(main())
