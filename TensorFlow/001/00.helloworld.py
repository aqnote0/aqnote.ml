import tensorflow as tf

hello = tf.constant('HelloWorld!')
sess = tf.Session()
print( sess.run(hello) )