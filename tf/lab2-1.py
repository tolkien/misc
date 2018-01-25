# -*- coding: utf-8 -*-
import tensorflow as tf

W = tf.Variable(tf.random_normal([1]), name='weight')
b = tf.Variable(tf.random_normal([1]), name='bias')
X = tf.placeholder(tf.float32, shape=[None])
Y = tf.placeholder(tf.float32, shape=[None])

hypothesis = X * W + b

cost = tf.reduce_mean(tf.square(hypothesis - Y))

optimizer = tf.train.GradientDescentOptimizer(learning_rate=0.01)
train = optimizer.minimize(cost)

# tensorboard에 point라는 이름으로 표시됨
cost_summary = tf.summary.scalar('cost_scalar', cost)
W_summary = tf.summary.scalar('W_scalar', W)
b_summary = tf.summary.scalar('b_scalar', b)
merged = tf.summary.merge_all()

sess = tf.Session()

# tensorboard output
writer = tf.summary.FileWriter('./board/lab2-1', sess.graph)

sess.run(tf.global_variables_initializer())
for step in range(2001):
	cost_, W_, b_, _ = sess.run([cost, W, b, train],
		feed_dict = {X: [1, 2, 3, 4, 5],
					Y: [2.1, 3.1, 4.1, 5.1, 6.1]})
	#sumary = [cost_, W_, b_]
	#writer.add_summary(summary, step)
	if step % 20 == 0:
		print(step, cost_, W_, b_)
