# ubuntu-nVidia-tensorflow-vnc
基于Ubuntu 18.04 Bionic 系统，且安装有cuda-10.0.130；cudnn-7.6.3.30；tensorflow-1.14.0； XFCE desktop with TurboVNC的镜像文件
基础镜像为nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04
#### 参考链接：
https://hub.docker.com/layers/nvidia/cuda/10.0-cudnn7-runtime-ubuntu14.04/images/sha256-0ea9dcee1fe81bce5dd4537a3ab28825a9fdb4e44878419b3a100eb3bd09b1ae
https://github.com/tyson-swetnam/ubuntu-xfce-vnc

#### 构造镜像
需在dockerfile文件中添加代码文件到指定目录，如果有需要可添加配置文件并用py脚本启动。[或者建立共享文件夹，在宿主机操作

2步构造参考命令
```
docker build -t object_detection:01 .
docker build -t nvidia_tf_vnc:01 -f object_detection_1+vnc .
```

1步构造参考命令
```
docker build -t nvidia_tf_vnc:01 -f dockerfile_all .
```

#### 启动参考命令
```
docker run -it --runtime=nvidia -p 5901:5901 -p 6901:6901 nvidia_tf_vnc:01
```

Run with OpenGL （没试过的命令）

```
docker run -it --runtime=nvidia -v /tmp/.X11-unix:/tmp/.X11-unix -v /tmp/.docker.xauth:/tmp/.docker.xauth -p 5901:5901 -p 6901:6901 tswetnam/ubuntu-xfce-vnc:opengl
```
#### 写在最后
最后生成的镜像有5G多，看起来并没有很好的发挥docker的优点。我想到了要用docker-compose，但是我理解的docker-compose的用法，好像不能互相为基础环境，最多只能互相通信。如果有好的想法，欢迎交流。
同时，如有错误，欢迎指正。哈哈~
