Feature



- [PHP配置模式](https://wileysec.com/archives/219/#menu_index_1)
- PHP安全配置
  - register_globals(全局变量注册开关)
    - [配置模式](https://wileysec.com/archives/219/#menu_index_4)
    - [默认配置](https://wileysec.com/archives/219/#menu_index_5)
  - allow_url_include(是否允许包含远程文件)
    - [配置模式](https://wileysec.com/archives/219/#menu_index_7)
    - [默认配置](https://wileysec.com/archives/219/#menu_index_8)
  - magic_quotes_gpc(魔术引号自动过滤)
    - [配置模式](https://wileysec.com/archives/219/#menu_index_10)
    - [默认配置](https://wileysec.com/archives/219/#menu_index_11)
    - [魔术引号自动过滤的配置](https://wileysec.com/archives/219/#menu_index_12)
  - Open_basedir(PHP可访问目录)
    - [配置模式](https://wileysec.com/archives/219/#menu_index_14)
    - [默认配置](https://wileysec.com/archives/219/#menu_index_15)
  - disable_functions(禁用函数)
    - [配置模式](https://wileysec.com/archives/219/#menu_index_17)
    - [默认配置](https://wileysec.com/archives/219/#menu_index_18)
  - display_errors 和 error_reporting(报错显示)
    - [配置模式](https://wileysec.com/archives/219/#menu_index_20)
    - [默认配置](https://wileysec.com/archives/219/#menu_index_21)
  - auto_prepend_file 和 auto_append_file(自动包含)
    - [配置模式](https://wileysec.com/archives/219/#menu_index_23)
    - [默认配置](https://wileysec.com/archives/219/#menu_index_24)



------



## PHP配置模式

PHP的配置文件 `php.ini`，PHP的配置文件中有很多模式，这些模式规定了PHP的配置向在什么情况下被设定。

通常设定配置项和修改配置项使用PHP脚本中的 `ini_set()` 设置，有些配置项只能在 `php.ini` 或者 `httpd.conf` 中设置或修改

| 模式           | 定义                                                       |
| :------------- | :--------------------------------------------------------- |
| PHP_INI_USER   | 该配置项模式可在用户PHP脚本或Windows注册表中设置           |
| PHP_INI_PERDIR | 该配置项模式可在 `php.ini` `.htaccess` `httpd.conf` 中设置 |
| PHP_INI_SYSTEM | 该配置项模式可在 `php.ini` `httpd.conf` 中设置             |
| PHP_INI_ALL    | 该配置项模式可在任何设定配置项的配置中设置                 |
| php.ini only   | 该配置项模式仅在 `php.ini` 中设置                          |



## PHP安全配置



### register_globals(全局变量注册开关)

> 配置项说明：当该配置为 `On` 时，会将用户 `GET` `POST` 提交的参数注册为全局变量并初始化参数对应的值，使得参数可以直接在脚本中使用。



#### 配置模式

PHP_INI_ALL



#### 默认配置

```
register_globals = Off
```

在 `PHP5.4.0` 版本开始已经移除该配置，受影响的版本只有在 `PHP5.4.0` 之前版本



### allow_url_include(是否允许包含远程文件)

> 配置项说明：当该配置项为 `On` 时，可包含远程文件



#### 配置模式

PHP_INI_SYSTEM



#### 默认配置

在 `PHP5.2.0` 以上版本，为关闭状态，`allow_url_include = Off`

该配置主要安全问题在于用户可控文件包含路径，可进行远程包含，从而进行 Getshell 操作



### magic_quotes_gpc(魔术引号自动过滤)

> 配置项说明：当该配置项为 `On` 时，会自动在 `GET` `POST` `COOKIE` 变量中将单引号(`'`)、双引号(`"`)、反斜杠(`\`)以及空白字符(`NULL`)前加上反斜杠(`\`)转义



#### 配置模式

```
PHP_INI_PERDIR
```



#### 默认配置

```
magic_quotes_gpc = On
```

该配置开启后，在没有进行特殊编码或者其他特殊绕过1的情况下，可以让很多漏洞无法利用。

但是该配置不会过滤 `$_SERVER` 变量，可以导致 `Client-IP` `REFERER` 漏洞能够被利用。



#### 魔术引号自动过滤的配置

- `magic_quotes_gpc`
- `magic_quotes_runtime`
- `magic_quotes_sybase`

上面三个配置开启为 `On` 时，都会过滤特殊字符，在 `PHP5.4.0` 及之后的版本被移除了。

一般PHP开发者都会使用过滤函数，而不是用配置文件过滤



### Open_basedir(PHP可访问目录)

> 配置项说明：该配置项将PHP能打开的文件限制在指定的目录树下，包括文件本身。



#### 配置模式

`PHP版本 < 5.2.3` PHP_INI_SYSTEM

`PHP版本 >= 5.2.3` PHP_INI_ALL



#### 默认配置

```
open_basedir = NULL
```

使用该配置项时，多个目录以分号分割 `;`

```
Open_basedir` 限制的是前缀，不是目录名，例如：`/www/a` 和 `/www/ab` 都能访问，如果要精确指定目录需使用目录格式 `/www/a/
```

配置后，脚本执行都会经过验证文件路径，对项目有一定的影响。



### disable_functions(禁用函数)

> 配置项说明：该配置项不允许执行用户基于安全原因禁用函数，多个函数使用逗号 `,` 分割



#### 配置模式

php.ini only



#### 默认配置

```
disable_functions = ""
```

在禁止一些危险函数执行时，`dl()` 函数加到禁止函数列表中，攻击者可利用`dl()` 函数加载自定义的PHP扩展突破 `disable_functions` 的限制



### display_errors 和 error_reporting(报错显示)

> 配置项说明：该配置项为 `On` 时，会将报错信息输出到页面上



#### 配置模式

PHP_INI_ALL



#### 默认配置

```
display_errors = On
```

该配置用于开发调试，在实际环境中都是进行关闭操作，以免被攻击者搜集到有用信息

当开启该配置项后，也可以在脚本中使用 `error_reporting()` 来设置错误显示的级别

`error_reporting(0)` 则不会显示任何错误信息



### auto_prepend_file 和 auto_append_file(自动包含)

> 配置项说明：该配置项用于设置在任何PHP脚本之前和之后自动包含文件



#### 配置模式

PHP_INI_PERDIR



#### 默认配置

```
auto_prepend_file = ""
```

该配置当设置为 `auto_prepend_file = "/www/security.php"` 时，`security.php` 会被同级目录下的其他PHP脚本文件运行之前包含。

通常该配置用于网页监控，在服务器安全检查中，也要查看该配置是否被黑客植入自动包含执行的木马