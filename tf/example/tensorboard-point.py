#!/usr/local/bin/python
# -*- coding: utf-8 -*-
import tensorflow as tf

a = tf.constant(3.0)
b = tf.constant(5.0)
c = a * b

# tensorboard에 point라는 이름으로 표시됨
c_summary = tf.summary.scalar('point', c)
merged = tf.summary.merge_all()

with tf.Session() as sess:
    writer = tf.summary.FileWriter('./board/sample_1', sess.graph)

    result = sess.run([merged])
    sess.run(tf.global_variables_initializer())

    writer.add_summary(result[0])

"""출처: http://pythonkim.tistory.com/39?category=574914 [파이쿵]"""
