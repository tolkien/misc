import tensorflow as tf
import functions

c1 = tf.constant([1, 3, 5, 7, 9, 0, 2, 4, 6, 8, 3, 7])
v1 = tf.Variable([[1, 2, 3], [7, 8, 9]])

print('-----------reshape------------')
functions.showOperation(tf.reshape(c1, [2, -1]))    # [[1 3 5 7 9 0] [2 4 6 8 3 7]]
functions.showOperation(tf.reshape(c1, [-1, 3]))    # [[1 3 5] [7 9 0] [2 4 6] [8 3 7]]
functions.showOperation(tf.reshape(v1, [-1]))       # [1 2 3 7 8 9]

c2 = tf.reshape(c1, [2, 2, 1, 3])
c3 = tf.reshape(c1, [1, 4, 1, 3, 1])

print('-----------squeeze------------')     # reemoves dimensions of size 1
# [[[[1 3 5]] [[7 9 0]]]  [[[2 4 6]] [[8 3 7]]]]
functions.showOperation(c2)
functions.showOperation(tf.squeeze(c2))    # [[[1 3 5] [7 9 0]]  [[2 4 6] [8 3 7]]]

# [[[[[1] [3] [5]]]  [[[7] [9] [0]]]  [[[2] [4] [6]]]  [[[8] [3] [7]]]]]
functions.showOperation(c3)
functions.showOperation(tf.squeeze(c3))    # [[1 3 5] [7 9 0] [2 4 6] [8 3 7]]


"""출처: http://pythonkim.tistory.com/66?category=574914 [파이쿵]"""