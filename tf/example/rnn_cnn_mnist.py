# Python 3, TensorFlow 1.0

import os
import tensorflow as tf
from tensorflow.examples.tutorials.mnist import input_data

tf.reset_default_graph()
mnist = input_data.read_data_sets("MNIST_data/", one_hot=True)

n_width = 28   # MNIST 이미지의 가로 크기, RNN의 input 갯수
n_height = 28  # MNIST 이미지의 세로 크기, RNN의 step 수
n_output = 10  # 0~9
learning_rate = 0.001
keep_prob = 0.6

def CNN(_X, training):
    input_X = tf.reshape(_X, [-1, 28, 28, 1])
    L1 = tf.layers.conv2d(inputs=input_X, filters=32, kernel_size=[3, 3],
                          padding='same', activation=tf.nn.relu)
    L1 = tf.layers.max_pooling2d(inputs=L1, pool_size=[2, 2], strides=2)

    L2 = tf.layers.conv2d(inputs=L1, filters=64, kernel_size=[3, 3],
                          padding='same', activation=tf.nn.relu)
    L2 = tf.layers.max_pooling2d(inputs=L2, pool_size=[2, 2], strides=2)
    L2 = tf.layers.dropout(inputs=L2, rate=keep_prob, training=training)

    L3 = tf.layers.conv2d(inputs=L2, filters=128, kernel_size=[3, 3],
                          padding='same', activation=tf.nn.relu)
    L3 = tf.layers.max_pooling2d(inputs=L3, pool_size=[2, 2], strides=2)

    L3 = tf.contrib.layers.flatten(L3)
    L4 = tf.layers.dense(inputs=L3, units=n_height * n_width, activation=tf.nn.relu)
    L4 = tf.layers.dropout(inputs=L4, rate=keep_prob, training=training)

    return tf.layers.dense(inputs=L4, units=n_output)

def RNN(_X, training):
    input_X = tf.reshape(_X, [-1, 28, 28])
    cell = tf.contrib.rnn.BasicLSTMCell(num_units=128)
    #_rate = tf.cond(training, true_fn=lambda: keep_prob, false_fn=lambda: 1.0)
    #cell = tf.contrib.rnn.DropoutWrapper(cell, output_keep_prob=_rate)
    #cell = tf.contrib.rnn.MultiRNNCell([cell] * 2)

    outputs, states = tf.nn.dynamic_rnn(cell, input_X, dtype=tf.float32)

    outputs = tf.contrib.layers.flatten(outputs)
    outputs = tf.layers.dense(inputs=outputs, units=n_height * n_width, activation=tf.nn.relu)
    outputs = tf.layers.dropout(inputs=outputs, rate=keep_prob, training=training)
    outputs = tf.layers.dense(inputs=outputs, units=n_output)

    return outputs


global_step = tf.Variable(0, trainable=False, name="global_step")
is_training = tf.placeholder(tf.bool)

X = tf.placeholder(tf.float32, [None, 784])
Y = tf.placeholder(tf.float32, [None, n_output])

CNN_model = CNN(X, is_training)
CNN_cost = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(logits=CNN_model, labels=Y))
CNN_optimizer = tf.train.AdamOptimizer(learning_rate).minimize(CNN_cost, global_step=global_step)

RNN_model = RNN(X, is_training)
RNN_cost = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(logits=RNN_model, labels=Y))
RNN_optimizer = tf.train.AdamOptimizer(learning_rate).minimize(RNN_cost, global_step=global_step)


#  Start
sess = tf.Session()
saver = tf.train.Saver(tf.global_variables())

ckpt = tf.train.get_checkpoint_state("./logs")
if ckpt and tf.train.checkpoint_exists(ckpt.model_checkpoint_path):
    saver.restore(sess, ckpt.model_checkpoint_path)
else:
    sess.run(tf.global_variables_initializer())


batch_size = 100
total_batch = int(mnist.train.num_examples/batch_size)

for epoch in range(15):
    CNN_cost_avg = 0
    RNN_cost_avg = 0

    for i in range(total_batch):
        batch_xs, batch_ys = mnist.train.next_batch(batch_size)

        _, CNN_cost_val  = sess.run([CNN_optimizer, CNN_cost],
                                    feed_dict={X: batch_xs, Y: batch_ys, is_training: True})
        _, RNN_cost_val = sess.run([RNN_optimizer, RNN_cost],
                                   feed_dict={X: batch_xs, Y: batch_ys, is_training: True})

        CNN_cost_avg += CNN_cost_val
        RNN_cost_avg += RNN_cost_val

    print('Epoch:', '%04d' % epoch, 'cost = %.4f, %.4f' % (
        CNN_cost_avg / total_batch, RNN_cost_avg / total_batch))

checkpoint_path = os.path.join("./logs", "mnist.ckpt")
saver.save(sess, checkpoint_path)

print('Learning Finished')


# accuracy
CNN_is_correct = tf.equal(tf.argmax(CNN_model, 1), tf.argmax(Y, 1))
CNN_accuracy = tf.reduce_mean(tf.cast(CNN_is_correct, tf.float32))

RNN_is_correct = tf.equal(tf.argmax(RNN_model, 1), tf.argmax(Y, 1))
RNN_accuracy = tf.reduce_mean(tf.cast(RNN_is_correct, tf.float32))

CNN_acc_val, RNN_acc_val = sess.run([CNN_accuracy, RNN_accuracy],
                                    feed_dict={X: mnist.test.images, Y: mnist.test.labels,
                                               is_training: False})

print('Accuracy: CNN %.4f, RNN %.4f' % (CNN_acc_val, RNN_acc_val))