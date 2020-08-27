- 标量类型：
  - 整型(int)
  - 浮点型(float)
  - 字符串(string)
  - 布尔型(boolean)
- 复合类型：
  - 对象(object)
  - 数组(array)
- 特殊类型：
  - 资源(resource)
  - NULL

- 整型 0；
- 浮点 0.0；
- 空字符串 ‘’；
- 零字符串 ‘0’；
- 布尔型 false；
- 空数组 array();
- NULL

- 直接赋值为NULL；
- 未定义的变量；
- unset销毁的变量；

- const 更快，是语言结构；可以定义类常量；
- define 是函数；不能定义类常量；

```
__FILE__; // 返回文件的路径名 和 文件的名称
__LINE__; // 所在行的行号
__DIR__; // 所在目录
__FUNCTION__; // 所在函数体中的函数名称
__CLASS__; // 类名
__TRAIT__; // trait的名称(PHP 5.4起的一个特性)
__METHOD__; // 类名 + 方法名
__NAMESPACE__; // namespace的名称
```

```
$_SERVER['SERVER_ADDR']; // 服务器端的IP地址【重点考察】
$_SERVER['SERVER_NAME']; // 服务器名称
$_SERVER['REQUEST_TIME']; // 启动时间
$_SERVER['QUERY_STRING']; // 问号后面的内容（有可能为空）
$_SERVER['HTTP_REFERER']; // 上级请求的页面（从哪过来的，也可能为空，从网址请求过来的时候，为空）
$_SERVER['HTTP_USER_AGENT']; // 返回头信息中user_agent的信息
$_SERVER['REMOTE_ADDR']; // 客户端的IP地址【重点考察】
$_SERGER['REQUEST_URI']; // 比如我们请求的是 index.php，此时 URI为 /index.php
$_SERVER['PATH_INFO']; // 用来处理路由或处理框架中路由的功能（抓取的是URL地址中的路径部分，既不是前面的脚本的名称，也不是后面的 $_SERVER['QUEST_STRING']）【如：访问 http://www.imooc.com/index.php/use/reg?status=ghost，则抓取的是 use/reg?status=ghost】

$GLOBALS; // 包含了后面的所有内容
$_GET
$_POST
$_REQUEST; // 包含了 $_GET、$_POST、$_COOKIE，【$_REQUEST尽量少用，它相当于一个万能钥匙，既可以接收 get/post/cookie，它的安全性偏低】
$_SESSION;
$_COOKIE;
$_SERVER;
$_FILES;
$_ENV;

```

