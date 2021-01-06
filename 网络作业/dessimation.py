import numpy as np
from numpy.linalg import cholesky
import matplotlib.pyplot as plt

import random


# 定义节点

class node(object):
    """"""

    def __init__(self, id, x, y, total_power, per_power, r, times=0):
        """
        id : id
        x,y : 坐标
        total_power : 总电量
        per_powerer ： 单次发射耗电量
        r : 通讯半径
        times : 发射几次了
        """
        self.id = id
        self.x = x
        self.y = y
        self.total_power = total_power
        self.per_power = total_power
        self.r = r
        self.times = times

    # 传输消耗能量
    def transmit(self):
        self.total_power -= self.per_power
        self.times += 1


# 初始化节点
def init_node(N, u, sigma, total_power, per_power):
    # 节点的x，y坐标 和 节点的发射半径
    x = np.random.randint(0, 100, size=N)
    y = np.random.randint(0, 100, size=N)
    R = np.random.normal(u, sigma, N)
    Node_list = []
    for i in range(N):
        tmp_node = node(i, x[i], y[i], total_power, per_power, R[i])
        Node_list.append(tmp_node)

    return Node_list


# 判断两个节点的通信成功率
def are_you_OK(d, r1, r2):
    t = 1 - d ** 2 / (r1 * r2 * 100)
    return t


# 计算两个节点间的距离
def distance(Node_A, Node_B):
    dis = ((Node_A.x - Node_B.x) ** 2 + (Node_A.y - Node_B.y) ** 2) ** 0.5
    return dis


# 计算出节点距离矩阵
def init_dis(Node_list, N):
    Distance_list = [[0 for i in range(N)] for i in range(N)]
    for i in range(N):
        for j in range(i + 1, N):
            dis = distance(Node_list[i], Node_list[j])
            Distance_list[i][j] = dis
            Distance_list[j][i] = dis

    return Distance_list


# 初始化红蓝矩阵， 蓝色代表还没传到消息，红色代表已经收到消息
def init_b_r(N):
    blue = [i for i in range(N)]
    red = []
    return blue, red


# 找到传播点的附近节点
def find_neighbor(source, num_spread, Distance_list, red, blue, flag="red"):
    sourceDis = Distance_list[source]  # 传播点与其他点的距离
    source_of_dis = np.sort(sourceDis)  # 按照距离排序
    source_of_idx = np.argsort(sourceDis)  # 按照距离排序后的原始index
    count = 0
    lis = []
    if flag == "red":
        lis = red
    else:
        lis = blue
    closest_of_dis = []
    closest_of_idx = []
    for i in range(1, len(source_of_dis)):
        # 如果该id已经传输过了就忽略
        if source_of_idx[i] in lis:
            continue
        else:
            closest_of_dis.append(source_of_dis[i])
            closest_of_idx.append(source_of_idx[i])
            count += 1
        # 找到满足的点的个数就停止
        if count >= num_spread:
            break

    return closest_of_dis, closest_of_idx


# 尝试传播
#  blue, red, trans_success, Node_list = spread(closest_of_idx[0], closest_of_dis, [id], Node_list, blue, red)
def spread(source, closest_of_dis, closest_of_idx, Node_list, blue, red):
    trans_success = []
    for ix, id in enumerate(closest_of_idx):
        rand_num = random.random()
        #         if len(closest_of_idx)==1:
        #             print("rand_num : ", rand_num)
        #             print("**",closest_of_dis[ix], Node_list[source].r, Node_list[id].r,"**")
        #             print("are_you_OK : ", are_you_OK(closest_of_dis[ix], Node_list[source].r, Node_list[id].r))
        #         are_you_OK(d,r1,r2)
        Node_list[source].transmit()
        if are_you_OK(closest_of_dis[ix], Node_list[source].r, Node_list[id].r) > rand_num:
            blue.remove(id)
            red.append(id)
            trans_success.append(id)

    return blue, red, trans_success, Node_list


# 描绘散点图
def draw_pic(blue, red, Node_list):
    fig = plt.figure(figsize=(10, 10))  # 新建画布
    ax = plt.subplot(1, 1, 1)  # 子图初始化
    #     ax.scatter(x,y) #绘制散点图
    # ax.scatter(x[1],y[1],c="red")
    for b in blue:
        ax.scatter(Node_list[b].x, Node_list[b].y, c="blue")
    for r in red:
        ax.scatter(Node_list[r].x, Node_list[r].y, c="red")
    ax.set_title("Spread Graph / red : Yes blue : No")
    ax.set_xlabel("x")
    ax.set_ylabel("y", rotation=0)

    for i in blue:
        ax.text(Node_list[i].x, Node_list[i].y, i,
                fontsize=8, color="black", style="italic", weight="light",
                verticalalignment='center', horizontalalignment='right', rotation=0)  # 给散点加标签
    for i in red:
        ax.text(Node_list[i].x, Node_list[i].y, i,
                fontsize=8, color="black", style="italic", weight="light",
                verticalalignment='center', horizontalalignment='right', rotation=0)  # 给散点加标签
    plt.show()


def energy_cost(Node_list):
    times_cost = 0
    for node in Node_list:
        times_cost += node.times

    return times_cost


def function_origin(blue, red, num_spread, Distance_list, Node_list, if_draw=False):
    rec_times = 0
    queue_Node = []
    N = len(Node_list)
    source = np.random.randint(0, N)
    print(source)
    queue_Node.append(source)
    while len(blue) > 0 and len(queue_Node) > 0:
        rec_times += 1
        source = queue_Node.pop()
        closest_of_dis, closest_of_idx = find_neighbor(source, num_spread, Distance_list, red, blue)
        blue, red, trans_success, Node_list = spread(source, closest_of_dis, closest_of_idx, Node_list, blue, red)
        print(trans_success)
        for it in trans_success:
            queue_Node.append(it)

        if if_draw:
            draw_pic(blue, red, Node_list)
    energy_c = energy_cost(Node_list)
    print("energy_cost", energy_c)
    print("rec_times : ", rec_times)
    return energy_c, rec_times


def function_break(blue, red, num_spread, Distance_list, Node_list, if_draw=False):
    rec_times = 0
    queue_Node = []
    N = len(Node_list)
    source = np.random.randint(0, N)
    print(source)
    queue_Node.append(source)
    while len(blue) > 0 and len(queue_Node) > 0:
        rec_times += 1
        source = queue_Node.pop()
        closest_of_dis, closest_of_idx = find_neighbor(source, num_spread, Distance_list, red, blue)
        blue, red, trans_success, Node_list = spread(source, closest_of_dis, closest_of_idx, Node_list, blue, red)
        print(trans_success)
        for it in trans_success:
            queue_Node.append(it)

        if if_draw:
            draw_pic(blue, red, Node_list)
        if len(blue) < 10:
            print(len(blue))
            break
    while len(blue) > 0:
        rec_times += 1
        for id in blue:
            closest_of_dis, closest_of_idx = find_neighbor(id, 1, Distance_list, red, blue, flag="blue")
            #             print("你找到谁了啊",closest_of_idx)
            #             print("你们离多远啊！",distance(Node_list[id],Node_list[closest_of_idx[0]]))
            blue, red, trans_success, Node_list = spread(closest_of_idx[0], closest_of_dis, [id], Node_list, blue, red)
            print("有漏网之鱼", id)
            print(trans_success)
        if if_draw:
            draw_pic(blue, red, Node_list)
    energy_c = energy_cost(Node_list)
    print("energy_cost", energy_c)
    print("rec_times : ", rec_times)
    return energy_c, rec_times


def function_clear(blue, red, num_spread, Distance_list, Node_list, if_draw=False):
    rec_times = 0
    queue_Node = []
    N = len(Node_list)
    source = np.random.randint(0, N)
    print(source)
    queue_Node.append(source)
    while len(blue) > 0 and len(queue_Node) > 0:
        rec_times += 1
        source = queue_Node.pop()
        closest_of_dis, closest_of_idx = find_neighbor(source, num_spread, Distance_list, red, blue)
        blue, red, trans_success, Node_list = spread(source, closest_of_dis, closest_of_idx, Node_list, blue, red)
        print(trans_success)
        for it in trans_success:
            queue_Node.append(it)

        if if_draw:
            draw_pic(blue, red, Node_list)
        if len(trans_success) == 0:
            queue_Node.clear()
            new_in = random.choice(blue)
            closest_of_dis, closest_of_idx = find_neighbor(new_in, 1, Distance_list, red, blue, flag="blue")
            queue_Node.append(closest_of_idx[0])
        if len(blue) < 10:
            print(len(blue))
            break
    while len(blue) > 0:
        rec_times += 1
        for id in blue:
            closest_of_dis, closest_of_idx = find_neighbor(id, 1, Distance_list, red, blue, flag="blue")
            #             print("你找到谁了啊",closest_of_idx)
            #             print("你们离多远啊！",distance(Node_list[id],Node_list[closest_of_idx[0]]))
            blue, red, trans_success, Node_list = spread(closest_of_idx[0], closest_of_dis, [id], Node_list, blue, red)
            print("有漏网之鱼", id)
            print(trans_success)
        if if_draw:
            draw_pic(blue, red, Node_list)
    energy_c = energy_cost(Node_list)
    print("energy_cost", energy_c)
    print("rec_times : ", rec_times)
    return energy_c, rec_times


def main(func_choice=3,if_draw=False):
    """超参数定义"""
    # 节点数量
    N = 300
    # u ,sigma
    u = 5
    sigma = 1
    num_spread=10
    total_power = 1
    per_power = 1e-5
    blue, red=init_b_r(N)
    Node_list=init_node(N, u, sigma, total_power, per_power)
    Distance_list=init_dis(Node_list, N)
    if func_choice==1:
        energy_c,rec_times=function_origin(blue, red, num_spread,Distance_list,Node_list,if_draw)
    elif func_choice==2:
        energy_c,rec_times=function_break(blue, red, num_spread,Distance_list,Node_list,if_draw)
    else :
        energy_c,rec_times=function_clear(blue, red, num_spread,Distance_list,Node_list,if_draw)
    return energy_c,rec_times


def test(epoches, test_costs, test_times, func_choice):
    test_times.clear()
    for i in range(epoches):
        enegy_c,rec_times=main(func_choice)
        test_costs.append(enegy_c)
        test_times.append(rec_times)
    return test_costs,test_times


def test_result():
    test_times1 = []
    test_times2 = []
    test_times3 = []
    test_costs1 = []
    test_costs2 = []
    test_costs3 = []
    test_cost1, test_times1 = test(50, test_costs1, test_times1, 1)
    test_cost2, test_times2 = test(50, test_costs2, test_times2, 2)
    test_cost3, test_times3 = test(50, test_costs3, test_times3, 3)

    x = [i for i in range(50)]
    plt.plot(x, test_times1, label="origin")
    plt.plot(x, test_times2, label="break")
    plt.plot(x, test_times3, label="clear")
    # plt.title("---epoch----")
    plt.legend()
    plt.show()

    x = [i for i in range(50)]
    plt.plot(x, test_costs1, label="origin")
    plt.plot(x, test_costs2, label="break")
    plt.plot(x, test_costs3, label="clear")
    plt.legend()
    plt.show()


if __name__=="__main__":
    main(3,True)