import tensorflow as tf
import functions

c1, c2, c3 = tf.constant([1, 2]), tf.constant([1.0, 2.0]), tf.constant([1])
v1, v2 = tf.Variable([1, 3]), tf.Variable([1.0, 3.0])

print('-----------equal------------')
functions.showOperation(tf.equal(c1, v1))           # [ True False]
functions.showOperation(tf.equal(c2, v2))           # [ True False]
# functions.showOperation(tf.equal(c1, c2))         # error. different type.

print('-----------not_equal------------')
functions.showOperation(tf.not_equal(c1, v1))       # [False  True]
functions.showOperation(tf.not_equal(c2, v2))       # [False  True]
# functions.showOperation(tf.not_equal(c1, c3))     # error. different size.

print('-----------less------------')
functions.showOperation(tf.less(c1, v1))            # [False  True]
functions.showOperation(tf.less(c2, v2))            # [False  True]

print('-----------less_equal------------')
functions.showOperation(tf.less_equal(c1, v1))      # [ True  True]
functions.showOperation(tf.less_equal(c2, v2))      # [ True  True]

print('-----------greater------------')
functions.showOperation(tf.greater(c1, v1))         # [False False]
functions.showOperation(tf.greater(c2, v2))         # [False False]

print('-----------greater_equal------------')
functions.showOperation(tf.greater_equal(c1, v1))   # [ True False]
functions.showOperation(tf.greater_equal(c2, v2))   # [ True False]

c4 = tf.constant([[1, 3], [5, 7]])
v4 = tf.Variable([[2, 4], [6, 8]])

# if True, select c4. if False, select v4.
cond1 = tf.Variable([[True, True ], [False, False]])
cond2 = tf.Variable([[True, False], [False, True ]])

print('-----------select------------')
functions.showOperation(tf.select(cond1, c4, v4))   # [[1 3] [6 8]]
functions.showOperation(tf.select(cond2, c4, v4))   # [[1 4] [6 7]]

c5 = tf.constant([[True , True], [False, False]])
v5 = tf.Variable([[False, True], [True , False]])

functions.showOperation(tf.where(c5))               # [[0 0] [0 1]]
functions.showOperation(tf.where(v5))               # [[0 1] [1 0]]

functions.showOperation(tf.select(cond1, c4, v4))   # [[1 3] [6 8]]
functions.showOperation(tf.select(cond2, c4, v4))   # [[1 4] [6 7]]

print('-----------and, or, xor, not------------')
functions.showOperation(tf.logical_and(c5, v5))     # [[False  True] [False False]]
functions.showOperation(tf.logical_or (c5, v5))     # [[ True  True] [ True False]]
functions.showOperation(tf.logical_xor(c5, v5))     # [[ True False] [ True False]]
functions.showOperation(tf.logical_not(c5))         # [[False False] [ True  True]]


"""출처: http://pythonkim.tistory.com/64?category=574914 [파이쿵]"""