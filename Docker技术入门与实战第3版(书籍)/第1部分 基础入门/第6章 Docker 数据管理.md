数据卷 ( Data Volumes ) : 容器内 数据直接映射到本地主机环境;
数据卷容器( Data Volume Containers ) : 使用特定容器维护数据卷 。

数据卷
数据卷 ( Data Volumes ) 是一个可供容器使用的特殊目录,它将主机操作系统目录直接
映射进容器,类似于 Linux 中的 mout 行为 。
数据卷可以提供很多有用的特性 :
  数据卷可以在容器之间共事和重用,容器间传递数据将变得高效与方便;
 对数据卷 内数据的修改会立马生效,无论是容器内操作还是本地操作;
 对数据卷的更新不会影响镜像,解摘开应用和数据 ;
    卷会一直存在 ,直到没有容器使用,可 以安全地卸载它 。

1. 创建数据卷
Docker 提供了 vo lume 子命令来管理数据卷,如下命令可以快速在本地创建一个数据卷:

 docker volume create -d local test
test
此时 ,查看/ v ar/lib / docker /vo lumes 路径下,会发现所创建的数据卷位置 :
$ ls -1 /var/l 工b/docker/volumes
drwxr - xr-x 3 root root 4096 May 22 06:02 test
除了 c reate 子命令外, docker volume 还支持 inspect (查看详细信息)、 l s (列
出已有数据卷)、 pru口e (清理无用数据卷)、 rm (删除数据卷)等,读者可以自行实践 。

2 绑定数据卷
除了使用 vo lume 子命令来管理数据卷外,还可以在创建容器时将主机本地的任 意路径
挂载到容器内作为数据卷,这种形式创建的数据卷称为绑定数据卷 。
在用 docker
[container]
ru口命令的时候,可以使用 - mount 选项来使用数据卷 。

- mount 选项支持三种类型的数据卷,包括 :
D vo lume : 普通数据卷,映射到主机/ var/ lib /docke r /vo lumes 路径下;
口 bind :绑定数据卷,映射到主机指定路径下;
D tmpfs :临时数据卷,只存在于内存中 。
下面使用 training/webapp 镜像创建一个 Web 容器,并创建一个数据卷挂载到容器
的/ opt/webapp 目录:
$ docker run
webapp
d
P
-name web
mount type=bind,source = /webapp,destination=/opt/
python app.py
tra 工n工 ng/webapp
上述命令等同于使用旧的 - v 标记可以在容器内创建一个数据卷:
$ docker run - d - P -- name web - v /webapp: /opt/webapp tra ining/webapp python app.py
这个功能在进行应用测试的时候十分方便,比如用户可以放置一些程序或数据到本地目
录中实时进行更新,然后在容器 内 运行和使用 。
另外,本地目录的路径必须是绝对路径,容器内路径可以为相对路径 。 如果目录不存
在, Docker 会自动创建 。
Docker 挂载数据卷的默认权限是读写( rw ) ,用户 也可以 通过 ro 指定为只读 :
$ docker
ru且- d
-P --name web -v /webapp: /opt/webapp:ro training/webapp python app.py
加了: ro 之后,容器内对所挂载数据卷内的数据就无法修改了 。
如果直接挂载一个文件到容器,使用文件编辑工具,包括 vi 或者 sed
- - in place
的时候,可能会造成文件 in ode 的改变 。 从 Docker 1.1.0 起,这会导致报错误信息 。 所以推
荐 的方式是直接挂载文件所在的目录到容器内。

利用数据卷容器来迁移数据