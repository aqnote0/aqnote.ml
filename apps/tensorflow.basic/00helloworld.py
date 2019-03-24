import tensorflow as tf

hello = tf.constant('HelloWorld!')
print( hello )

session = tf.Session()
result = session.run(hello)
print( result )