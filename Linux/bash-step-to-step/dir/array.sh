#!/bin/bash
array=(10 20 30 40 50)

# 
echo '显示数组中所有元素'
echo ${array[*]}
echo ${array[@]}

# 
echo '显示数组第2项'
echo ${array[1]}

# 
echo '显示数组长度'
echo ${#array[@]}

# 
echo '输出数组的第1-3项'
echo ${array[@]:0:3}

#
echo '将数组中的0替换成1'
echo ${array[@]/0/1}

#
#
#
echo '删除数组第2项元素'
unset array[1]
echo ${array[@]}

exit 0