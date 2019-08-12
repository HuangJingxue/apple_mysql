# mysql 5.6多库并行复制原理：

> 开启这个并行复制，需要设定slave_parallel_workers参数，这个参数如果设定成0的话代表不使用并行，relaylog由sql线程执行，表现和之前版本一致。当这个参数设置成n时，会有n个worker线程，由它来执行event，原来的sql变成coordinator线程，由它来读取relaylog，并按照一定规则将读到的event分配给worker线程执行，从这里可以看出，如果slave_parallel_workers被设置成1的话不仅不会增加效率，相反还会有所下降。

![](C:\Users\Apple\Pictures\Saved Pictures\5.6并行复制.png)