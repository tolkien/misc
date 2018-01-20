import tensorflow as tf
import numpy as np

x_data = [1., 2., 3.]
y_data = [2., 4., 6.]

W = tf.Variable(0.5)
X = tf.placeholder(tf.float32)

hypothesis = W * X
cost = tf.reduce_mean(tf.square(hypothesis-y_data))
rate = tf.constant(0.1)

optimizer = tf.train.GradientDescentOptimizer(rate)
train = optimizer.minimize(cost)

sess = tf.Session()
sess.run(tf.initialize_all_variables())

for i in range(3):
    sess.run(train, feed_dict={X: x_data})
    print(i, sess.run(W))
print('-'*30)

t = np.array([3.6])                 # x가 3.6일 때의 y 예측 시도
ww = sess.run(W)
hh = sess.run(hypothesis, {X: t})

print('manual     : {}'.format((ww*t)[0]))
print('hypothesis : {}'.format(hh[0]))


"""출처: http://pythonkim.tistory.com/72?category=574914 [파이쿵]"""