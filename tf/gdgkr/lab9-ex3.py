
# coding: utf-8

# Deep NN for MNIST
# add TensorBoard

# In[1]:


# Deep NN for MNIST
import tensorflow as tf
import numpy as np
import random
tf.set_random_seed(777)  # for reproducibility

from tensorflow.examples.tutorials.mnist import input_data
# Check out https://www.tensorflow.org/get_started/mnist/beginners for
# more information about the mnist dataset
mnist = input_data.read_data_sets("MNIST_data/", one_hot=True)

nb_classes = 10

# MNIST data image of shape 28 * 28 = 784
X = tf.placeholder(tf.float32, [None, 784], name='x-input')
# 0 - 9 digits recognition = 10 classes
Y = tf.placeholder(tf.float32, [None, nb_classes], name='y-input')
#print(X, Y)

W1 = []
b1 = []
x1 = []
y1 = []
w1_hist = []
b1_hist = []
layer1_hist = []
with tf.name_scope("layer1") as scope:
    for i in range(28):
        j = (i)*28
        k = (i+1)*28
        x1.append(X[:,j:k])
        #print("[%2d] %d:%d %d" % (i, j, k, k - j))
        W1.append( tf.Variable(tf.random_normal([28, 32]), name='weightA%d' % (i)) )
        b1.append( tf.Variable(tf.random_normal([32]), name='biasA%d' % (i)) )
        y1.append( tf.nn.softmax(tf.matmul(x1[i], W1[i]) + b1[i]) )
        #print("[%2d]" % i, x1[i].get_shape().dims[-1],
        #      "X:", x1[i].shape, "W:", W1[i].shape, "b:", b1[i].shape, "y:", y1[i].shape)

        w1_hist.append( tf.summary.histogram("weightA%d" % (i), W1[i]) )
        b1_hist.append( tf.summary.histogram("biasA%d" % (i), b1[i]) )
        layer1_hist.append( tf.summary.histogram("layer1_%d" % (i), y1[i]) )

    print("X:", X.shape, "x1:", x1[0].shape, len(x1), "W1:", W1[0].shape, len(W1),
          "b1:", b1[0].shape, len(b1), "y1:", y1[0].shape, len(y1))

W2 = []
b2 = tf.Variable(tf.random_normal([nb_classes]))
y2 = b2
w2_hist = []
with tf.name_scope("layer2") as scope:
    for i in range(28):
        W2.append( tf.Variable(tf.random_normal([32, nb_classes]), name='weightB%d' % (i)) )
        y2 += tf.matmul(y1[i], W2[i])
        
        w2_hist.append( tf.summary.histogram("weightB%d" % (i), W2[i]) )

    b2_hist = tf.summary.histogram("biasB", b2)
    print("y1:", y1[0].shape, len(y1), "W2:", W2[0].shape, len(W2),
          "b2:", b2.shape, "y2:", y2.shape)
    
    # Hypothesis (using softmax)
    hypothesis = tf.nn.softmax(y2)
    hypothesis_hist = tf.summary.histogram("hypothesis", hypothesis)


# In[2]:


with tf.name_scope("cost") as scope:
    cost = tf.reduce_mean(-tf.reduce_sum(Y * tf.log(hypothesis), axis=1))
    cost_hist = tf.summary.scalar("cost", cost)

with tf.name_scope("train") as scope:
    optimizer = tf.train.GradientDescentOptimizer(learning_rate=0.1).minimize(cost)

# Test model
is_correct = tf.equal(tf.argmax(hypothesis, 1), tf.argmax(Y, 1))
# Calculate accuracy
accuracy = tf.reduce_mean(tf.cast(is_correct, tf.float32))
accuracy_hist = tf.summary.scalar("accuracy", accuracy)

# parameters
training_epochs = 15
batch_size = 100

# tensorboard --logdir=./logs
merged_summary = tf.summary.merge_all()
writer = tf.summary.FileWriter("./logs/xor_logs_r9_03")

with tf.Session() as sess:
    # Initialize TensorFlow variables
    sess.run(tf.global_variables_initializer())
    writer.add_graph(sess.graph)

    # Training cycle
    for epoch in range(training_epochs):
        avg_cost = 0
        total_batch = int(mnist.train.num_examples / batch_size)

        for i in range(total_batch):
            batch_xs, batch_ys = mnist.train.next_batch(batch_size)
            s, c, _ = sess.run([merged_summary, cost, optimizer],
                               feed_dict={X: batch_xs, Y: batch_ys})
            avg_cost += c / total_batch
            writer.add_summary(s, global_step=epoch*total_batch+i)

        print('Epoch:', '%04d' % (epoch + 1),
              'cost =', '{:.9f}'.format(avg_cost))

    print("Learning finished")

    # Test the model using test sets
    print("Accuracy: ", accuracy.eval(session=sess, feed_dict={
          X: mnist.test.images, Y: mnist.test.labels}))

    # Get one and predict
    r = random.randint(0, mnist.test.num_examples - 1)
    print("Label: ", sess.run(tf.argmax(mnist.test.labels[r:r + 1], 1)))
    print("Prediction: ", sess.run(
        tf.argmax(hypothesis, 1), feed_dict={X: mnist.test.images[r:r + 1]}))
