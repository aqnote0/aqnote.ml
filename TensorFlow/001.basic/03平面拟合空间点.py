import sys
import numpy as np
import tensorflow as tf

# 平面拟合空间随机点

# 使用 NumPy 生成假数据(phony data), 总共 100 个点.
## 返回A(2,100)数组
x_data = np.float32(np.random.rand(2, 100))
## 返回[0.100, 0.200] 和 x_data相乘，结果为A(1, 100)
y_data = np.dot([3.3, 3.4], x_data) + 0.300

# 构造一个线性模型
## 返回一个数
b = tf.Variable( tf.zeros([1]) )
## 返回1*2的张量，值介于-1.0和1.0之间，产生的值是均匀分布的
W = tf.Variable( tf.random_uniform([1, 2], -1.0, 1.0) )
## 将矩阵W 乘于 矩阵x_data，结果为A(1, 100)
y = tf.matmul( W, x_data ) + b

# 最小化方差
## loss函数：reduce_mean求张量平均值；square对每个元素就2乘方
with tf.name_scope('loss'):
    loss = tf.reduce_mean(tf.square(y - y_data))
    tf.summary.scalar('loss', loss)
    
## Train方法，梯度下降
with tf.name_scope('train'):
    train = tf.train.GradientDescentOptimizer(0.5).minimize(loss)

# 初始化变量
init = tf.global_variables_initializer()
session = tf.Session()
session.run(init)

## TensorBoard
merged = tf.summary.merge_all()
writer = tf.summary.FileWriter('logs/',session.graph)

# 回归
for step in range(0, 500):
    session.run(train)
    if step % 20 == 0:
        result = session.run(merged)
        writer.add_summary(result, step)
        print( '%10s' % step, '%25s' % session.run(W), '%20s' % session.run(b), '%20s' % session.run(loss) )

# 得到最佳拟合结果 W: [[0.100  0.200]], b: [0.300]
