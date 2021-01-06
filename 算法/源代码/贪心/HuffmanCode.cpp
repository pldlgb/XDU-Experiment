//
// Created by 叫我浑醉好了 on 2020/4/22.
//
#include "liblys.h"
//typedef struct treeNode {
//    treeNode * lchild, * rchild;
//    char ch;
//    int weight;
//    string huffCode;
//    //带初始化列表得到构造函数
//    treeNode():lchild(NULL),rchild(NULL),ch('\0'),weight(0),huffCode(""){}
//}treeNode,*tree;
//定义比较体
struct cmp {
    bool operator() (treeNode *a, treeNode * b) {
        return a->weight > b->weight;
    }
};
//最小堆
priority_queue < treeNode*, vector<treeNode*>, cmp > pque;
treeNode * createHuffTree(vector<char> vch,vector<int> vfreq) {
    //构建树节点，放入优先级队列
    for (int i = 0; i < vch.size(); i++) {
        treeNode * t = new treeNode;
        t->ch = vch[i];
        t->weight = vfreq[i];
        pque.push(t);
    }

    while (pque.size() != 1) {
        //依次找出最小的两个节点
        treeNode *a, *b;
        a = pque.top();
        pque.pop();
        b = pque.top();
        pque.pop();
        //连成一棵树
        treeNode * temp = new treeNode;
        temp->weight = a->weight + b->weight;
        temp->lchild = a;
        temp->rchild = b;
        pque.push(temp);
    }
    return pque.top();
}
//遍历哈夫曼树，打印哈夫曼编码
void createHuffCode(treeNode * root) {
    //左孩子打‘0’，并递归打‘0’
    if (root->lchild) {
        root->lchild->huffCode =root->huffCode+ "0";
        createHuffCode(root->lchild);
    }
    //如果是叶子结点，打印
    if (!(root->lchild) && !(root->rchild)) {
        //打印字符
        cout << root->ch << " ";
        //打印编码
        cout << root->huffCode;
        cout << endl;
    }
    if (root->rchild) {
        root->rchild->huffCode = root->huffCode + "1";
        createHuffCode(root->rchild);
    }
    return ;
}

