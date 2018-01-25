# -*- coding: utf-8 -*-
import tensorflow as tf
import functions

c1, c2 = tf.constant([3]), tf.constant([1, 5])
v1, v2 = tf.Variable([5]), tf.Variable([2, 4])

functions.showConstant(c1)
functions.showConstant(c2)
functions.showVariable(v1)
functions.showVariable(v2)

print('-----------add------------')
functions.showOperation(tf.add(c1, v1))         # [8]
functions.showOperation(tf.add(c2, v2))         # [3 9]
functions.showOperation(tf.add([c2, v2], [c2, v2]))   # [[ 2 10] [ 4  8]]

print('-----------sub------------')
functions.showOperation(tf.sub(c1, v1))         # [-2]
functions.showOperation(tf.sub(c2, v2))         # [-1  1]

print('-----------mul------------')
functions.showOperation(tf.mul(c1, v1))         # [15]
functions.showOperation(tf.mul(c2, v2))         # [ 2 20]

print('-----------div------------')
functions.showOperation(tf.div(c1, v1))         # [0]
functions.showOperation(tf.div(c2, v2))         # [0 1]

print('-----------truediv------------')
functions.showOperation(tf.truediv(c1, v1))     # [ 0.6]
functions.showOperation(tf.truediv(c2, v2))     # [ 0.5  1.25]

print('-----------floordiv------------')
functions.showOperation(tf.floordiv(c1, v1))    # [0]
functions.showOperation(tf.floordiv(c2, v2))    # [0 1]

print('-----------mod------------')
functions.showOperation(tf.mod(c1, v1))         # [3]
functions.showOperation(tf.mod(c2, v2))         # [1 1]


"""출처: http://pythonkim.tistory.com/63?category=574914 [파이쿵]"""
