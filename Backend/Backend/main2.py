import numpy as np
import matplotlib.pyplot as plt

import matplotlib.pyplot as plt

from skimage import filters
from skimage import color
from skimage import measure
from skimage import feature
from skimage import exposure
from skimage import filters
from skimage import io
from skimage.morphology import disk
import skimage
import collections as cl
from skimage.color.adapt_rgb import adapt_rgb, each_channel, hsv_value

import scipy.ndimage
import time

import os

from skimage.io import imread

import sys

sys.setrecursionlimit(2000000000)

from skimage import transform

import warnings

warnings.filterwarnings("ignore")
import keras
import copy

loaded_model = keras.models.load_model('finalized_model_printed_CNN_280000_45_45_50_handwriten_charecters_fat.sav')
mapat = np.load('mapat.npy')


@adapt_rgb(each_channel)
def sobel_each(image):
    return filters.sobel(image)


def gr_erosion(image):
    image2 = copy.copy(image)
    image2[:, :, 0] = scipy.ndimage.grey_erosion(image2[:, :, 0], (3, 3))
    image2[:, :, 1] = scipy.ndimage.grey_erosion(image2[:, :, 1], (3, 3))
    image2[:, :, 2] = scipy.ndimage.grey_erosion(image2[:, :, 2], (3, 3))
    return image2


def get_symbol(picture):
    cnt = 0
    for i in range(picture.shape[0]):
        if picture[i] > 250:
            picture[i] = 0
            cnt += 1
        else:
            picture[i] = 1
    if cnt * 4 > 45 * 45 * 3:
        return '*'
    picture = picture.reshape(45, 45)
    picture2 = np.zeros(45 * 45)
    picture2 = picture2.reshape(45, 45)
    for i in range(0, 45):
        for j in range(0, 45):
            if i == 0 or i == 44 or j == 0 or j == 44 and picture[i, j] == 1:
                picture2[i, j] = 1
            elif (picture[i - 1, j] == 1 and picture[i + 1, j] == 1 and picture[i, j - 1] == 1 and picture[
                i, j + 1] == 1):
                picture2[i, j] = 1
            else:
                picture2[i, j] = 0
    picture = picture2.reshape(1, 45, 45, 1)
    preds = loaded_model.predict(picture)
    mx = 0
    for i in range(43):
        if preds[0, mx] < preds[0, i]:
            mx = i
    # print(mapat[mx])
    return mapat[mx]


def upd(image, cnt1, cnt2, n, shift):
    for ll in range(n):
        image2 = np.zeros(image.shape)
        for i in range(image.shape[0]):
            for j in range(image.shape[1]):
                cnt = np.sum(image[i - shift:i + shift + 1, j - shift:j + shift + 1]) / 255
                cnt = (2 * shift + 1) ** 2 - cnt
                if cnt >= cnt1:
                    image2[i][j] = 0
                elif cnt <= cnt2:
                    image2[i][j] = 255
                else:
                    image2[i][j] = image[i][j]
        image = image2
    return image


def recognize(filepath):
    start_time = time.time()
    formules = imread(filepath)

    # formules = transform.rescale(formules, 0.5)
    # skimage.io.imsave('formules_downscaled.jpg', formules)
    # formules = np.array(formules) * 255

    formules = sobel_each(formules) * 255

    h = formules.shape[0]
    w = formules.shape[1]

    h = formules.shape[0]
    w = formules.shape[1]
    summ = formules.mean() * 3 + 25
    formules2 = np.zeros((h, w))
    for i in range(h):
        for j in range(w):
            if (formules[i][j].sum() > summ):
                formules2[i][j] = 0
            else:
                formules2[i][j] = 255

    formules = formules2

    #upd(formules, 6, 2)
    #upd(formules, 3, 3)

    formules = upd(formules, cnt1=12, cnt2=8, n=2, shift=2)

    formules = upd(formules, cnt1=19, cnt2=10, n=4, shift=2)

    skimage.io.imsave('kek.jpg', formules / 255)
    return

    used = [False for i in range(h * w)]
    comp = [0 for i in range(h * w)]

    formules = formules.reshape((h * w,))

    dists = []

    def can_go(i, j):
        # print(np.sum((formules[i, :3] - formules[j, :3]) ** 2))
        if not used[j] and np.sum((formules[i, :3] - formules[j, :3]) ** 2) < 250:
            dists.append(np.sum((formules[i, :3] - formules[j, :3]) ** 2))
            return True
        else:
            return False

    def dfs(v, cmp):
        st = cl.deque()
        st.append((v, cmp))
        cnt = 0

        while len(st) > 0:
            cnt += 1
            if cnt % 1000:
                # print(cnt)
                pass
            v, cmp = st.pop()

            used[v] = True
            comp[v] = cmp
            x = v % w
            y = v // w
            if x > 0 and can_go(v, y * w + x - 1):
                st.append((y * w + x - 1, cmp))
            if x < w - 1 and can_go(v, y * w + x + 1):
                st.append((y * w + x + 1, cmp))
            if y > 0 and can_go(v, (y - 1) * w + x):
                st.append(((y - 1) * w + x, cmp))
            if y < h - 1 and can_go(v, (y + 1) * w + x):
                st.append(((y + 1) * w + x, cmp))
            if x > 0 and y > 0 and can_go(v, (y - 1) * w + x - 1):
                st.append(((y - 1) * w + x - 1, cmp))
            if x > 0 and y < h - 1 and can_go(v, (y + 1) * 2 + x - 1):
                st.append(((y + 1) * w + x - 1, cmp))
            if x < w - 1 and y > 0 and can_go(v, (y - 1) * w + x + 1):
                st.append(((y - 1) * w + x + 1, cmp))
            if x < w - 1 and y < h - 1 and can_go(v, (y + 1) * w + x + 1):
                st.append(((y + 1) * w + x + 1, cmp))

    now = 1
    for i in range(w * h):
        if not used[i]:
            dfs(i, now)
            now += 1

    dists = np.array(dists)
    print(dists[:20])
    print(now)
    print('shape = ', dists.shape)
    print('mean = ', np.mean(dists))
    print('median = ', np.median(dists))
    print('max = ', np.max(dists))
    print('min = ', np.min(dists))

    vers = [[] for i in range(now)]
    for i in range(h * w):
        vers[comp[i]].append(i)

    colors = np.random.rand(now, 3)
    arr = np.zeros((h, w, 3))
    for i in range(h):
        for j in range(w):
            arr[i, j] = colors[comp[i * w + j]]
    skimage.io.imsave('colored9.jpg', arr)

    zones = {}
    zones["items"] = []

    now1 = 0
    for i in range(1, now):
        x_min, y_min = 100000, 100000
        x_max, y_max = -1, -1
        for v in vers[i]:
            x = v % w
            y = v // w
            x_min = min(x_min, x)
            x_max = max(x_max, x)
            y_min = min(y_min, y)
            y_max = max(y_max, y)
        h_now = y_max - y_min + 1
        w_now = x_max - x_min + 1
        con = max(h_now, w_now)
        con = 0
        x_dif = max(con // 10, con // 10 + w_now - h_now)
        y_dif = max(con // 10, con // 10 + h_now - w_now)
        x_dif, y_dif = y_dif, x_dif
        now2 = np.zeros((w_now + x_dif, h_now + y_dif))
        for v in vers[i]:
            x = v % w
            y = v // w
            now2[y - y_min + y_dif // 2][x - x_min + x_dif // 2] += 255
        if x_max - x_min < 5 or y_max - y_min < 5:
            now1 += 1
            continue
        now2 = transform.resize(now2, (45, 45))
        now2 = np.array(now2).reshape(2025)
        arr = {}
        arr["str"] = get_symbol(now2)
        arr["x1"] = x_min
        arr["y1"] = y_min
        arr["x2"] = x_max
        arr["y2"] = y_max
        zones["items"].append(arr)
    print(now1)
    return zones
