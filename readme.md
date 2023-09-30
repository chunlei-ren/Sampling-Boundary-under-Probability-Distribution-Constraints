# 抽样边界实验文档

## 实验流程简介

* 首先根据获取大小为$10^6$贝叶斯数据集（`.net`文件包含贝叶斯网络的所有结点及其取值，包含贝叶斯网络的条件概率分布，即所有的$\theta_{ijk}$），并进行预处理
* 根据所生成的数据集，获取贝叶斯网络的相关参数，如$\theta_{ijk}$，$\gamma_{ij}$等
* 进行抽样边界实验

## 贝叶斯数据集的生成和处理

### 步骤0：声明

以贝叶斯网络`survey`为例，介绍如何生成和处理贝叶斯数据集。

1. 首先，需要从[网站bnlearn](https://www.bnlearn.com/bnrepository/)找到贝叶斯网络`survey`，下载两个文件：
    - 后缀名为`.rda`的文件
    - 后缀名为`.net`的文件
2. 然后，将这两个文件分别重命名为`survey.rda`和`survey.net`，放到目录**`E:/BayesianDataset/survey`**下。该目录将存放后续实验所需要的所有文件。



### 步骤1：生成初步的贝叶斯数据集

* 功能：生成贝叶斯数据集
* 输入：文件`E:/BayesianDataset/survey/survey.rda`
* 输出：文件`E:/BayesianDataset/survey/survey.csv`，该文件即为初步生成的贝叶斯数据集。第一行为贝叶斯数据集属性的名称，第一列为数据编号。从第二行开始，每一行表示一个数据。
* 环境配置：首先需要安装R语言；然后需要安装`bnlearn`包，安装教程详见[网站bnlearn](https://www.bnlearn.com/)


```R
library("bnlearn") # 加载贝叶斯网络包bnlearn
temp <- load("E:/BayesianDataset/survey/survey.rda") # rda文件所在的路径
temp_data <- rbn(bn, n = 1000000) # 生成贝叶斯数据集，并通过参数n指定数据集大小
# 保存上一步生成的贝叶斯数据集，通过file参数指定保存路径、数据集文件文件名以及文件格式
write.csv(temp_data, file = "E:/BayesianDataset/survey/survey.csv", quote = FALSE)
```



### 步骤2：处理贝叶斯数据集

* 功能：处理贝叶斯数据集文件`E:/BayesianDataset/survey/survey.csv`
* 输入：需要准备好两个文件，即
    1. 文件`E:/BayesianDataset/survey/survey.csv`
    2. 文件`E:/BayesianDataset/survey/survey.net`

* 输出：三个文件，即
    1. 文件`E:/BayesianDataset/survey/survey_p.txt`：处理后的贝叶斯数据集文件，每一行表示一个数据。
    2. 文件`E:/BayesianDataset/survey/nodeValueNum.txt`：仅有一行，第`i`列表示贝叶斯网络`survey`中第`i`个结点的取值数量
    3. 文件`E:/BayesianDataset/survey/parent.txt`：第`i`行中的非零值表示第`i`个结点对应的父结点的编号

* 环境配置：Python3环境，需要安装`numpy`和`pandas`

```python
import pandas as pd
import numpy as np
import re

# 字典类型，key为结点名称，value为结点取值
node_name_state = dict()
node_names = list()
node_nums = 0


def get_params(root_name: str, dataset_name: str):
    global node_nums, node_names, node_name_state
    net_fn = root_name + dataset_name + "/" + dataset_name + ".net"
    with open(net_fn, "r") as fp:
        net = fp.read()
        # 网络中的结点
        node_pat = re.compile(r"node \w+")
        nodes = node_pat.findall(net)
        # 结点数量
        node_nums = len(nodes)
        for n in nodes:
            node_names.append(n.split(" ")[1])
        # 每个结点的取值
        state_pat = re.compile(r"states = [\w\(\)\" ]+;")
        states = state_pat.findall(net)
        for i in range(node_nums):
            nt = nodes[i].split(" ")[1]
            st = states[i].split("\"")
            stl = list()
            for j in range(len(st)):
                if j % 2 == 1:
                    stl.append(st[j])
            node_name_state[nt] = tuple(stl)
        # 网络中的条件概率
        potential_pat = re.compile(r"potential \( [\w |]+ \)")
        potential = potential_pat.findall(net)
        # 去除冗余部分
        potential2 = list()
        for i in range(node_nums):
            pt = potential[i].split("(")[1]
            pt = pt.split(")")[0]
            pt = pt.strip()
            potential2.append(pt)
        # 字典类型，key为结点名称，value为对应结点的所有父结点
        node_name_parent = dict()
        for i in range(node_nums):
            pt = potential2[i]
            t = pt.split(" | ")
            if len(t) == 1:
                node_name_parent[t[0]] = tuple()
            if len(t) == 2:
                node_name_parent[t[0]] = tuple(t[1].split(" "))
    # 获取编码
    node_name_code = dict()
    for i in range(node_nums):
        node_name_code[node_names[i]] = i + 1
    # 获取结点取值数量文件
    node_val_nums = list()
    for k in node_name_state:
        node_val_nums.append(str(len(node_name_state[k])))
    fn = root_name + dataset_name + "/" + "nodeValueNum.txt"
    with open(fn, "w") as fp:
        t = " ".join(node_val_nums)
        fp.write(t)
    # 获取父结点文件
    parent_arr = np.zeros((node_nums, node_nums), dtype=int)
    arc_nums = 0
    for k in node_names:
        parent = node_name_parent[k]
        node_code = node_name_code[k]
        parent_code = list()
        for i in range(len(parent)):
            parent_code.append(node_name_code[parent[i]])
        parent_code = sorted(parent_code)
        for i in range(len(parent_code)):
            parent_arr[node_code - 1, i] = parent_code[i]
            arc_nums += 1
    fn = root_name + dataset_name + "/parent.txt"
    np.savetxt(fn, parent_arr, fmt="%d")
    print("-"*20)
    print("数据集：", dataset_name)
    print("结点数量：", node_nums)
    print("弧的数量：", arc_nums)


def format_data(root_name: str, dataset_name: str):
    # 读取数据集文件
    fn = root_name + dataset_name + "/" + dataset_name + ".csv"
    data = pd.read_csv(fn, dtype=str)
    data = data.iloc[:, 1:]
    # 将每一个属性的取值编码
    for i in range(node_nums):
        print("数据格式化中，正在格式化第", i+1, "个结点的数据（共", node_nums, "个结点）")
        node_name = data.columns[i]
        node_name_vals = node_name_state[node_name]
        val_code = dict()
        for j in range(len(node_name_vals)):
            val_code[node_name_vals[j]] = j
        data.iloc[:, i].replace(val_code, inplace=True)
    to_fn = root_name + dataset_name + "/" + dataset_name + "_p.txt"
    data.to_csv(to_fn, index=False, header=False, sep=" ")
    print("Over!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")


if __name__ == "__main__":
    # 文件根目录
    root = "E:/BayesianDataset/"
    # 数据集名称
    dn = "survey"
    get_params(root, dn)
    format_data(root, dn)



```



### 步骤3：获取后续实验所需的各种变量（相关代码放在文件夹`get_all_variables`中）

* 功能：获取后续实验涉及到的一些变量。配置三个文件，运行`get_all_variables/main.m`即可
* 输入：需要配置三个文件，即
    1. 数据集文件`E:/BayesianDataset/survey/survey_p.txt`：由步骤2生成
    2. 取值数量文件`E:/BayesianDataset/survey/nodeValueNum.txt`：由步骤2生成
    3. 父结点文件`E:/BayesianDataset/survey/parent.txt`：由步骤2生成
* 输出：输出文件为`E:/BayesianDataset/survey.mat`文件
* 环境配置：本代码在Matlab2019可以运行。

## 抽样下界实验

- 环境配置：（1）Matlab2019；（2）在matlab安装CVX工具包；（3）取得Mosek求解器的licence，用于求解整数线性规划
- 实验代码：位于文件夹`3_lb`内。
    - `3_lb/lb_absolute_cvx.m`：求解单个绝对误差下的抽样上界
    - `3_lb/lb_absolute_cvx_multi.m`：求解多个绝对误差下的抽样上界
    - `3_lb/lb_relative_cvx.m`：求解单个相对误差下的抽样上界
    - `3_lb/lb_relative_cvx_multi.m`：求解多个相对误差下的抽样上界

## 抽样上界实验

* 环境配置：Matlab2019
* 实验代码。相对误差下抽样上界的求解位于文件夹`2_1_ub_rel_rel`内，绝对误差的位于`2_2_ub_abs_abs`内。
    * `2_1_ub_rel_rel/ub.m`：求解单个相对误差下的抽样上界
    * `2_1_ub_rel_rel/ub_multi.m`：求解多个相对误差下的抽样上界
    * `2_2_ub_abs_abs/ub.m`：求解单个绝对误差下的抽样上界
    * `2_2_ub_abs_abs/ub_multi.m`：求解多个绝对误差下的抽样上界
