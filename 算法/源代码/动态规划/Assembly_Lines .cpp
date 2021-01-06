//
// Created by 叫我浑醉好了 on 2020/4/20.
//
#include "liblys.h"
//line1表示装配线一的花费，line2同理
//cost1表示装配线1转到2的花费，cost2同理
//与ppt不同，此代码将初始进入装配线的花费和退出装配线的花费加入到cost数组中
int Assembly_Lines(vector<int> &line1,vector<int> &line2,vector<int> cost1,vector<int> cost2,vector<int> &route){
//    vector<int>line1={7,9,3,4,8,4};
//    vector<int>line2={8,5,6,4,5,7};
//    vector<int>cost1={2,2,3,1,3,4,3};
//    vector<int>cost2={4,2,1,2,2,1,2};
    //进入装配线，直接在line上修改
    line1[0]=cost1[0]+line1[0];
    line2[0]=cost2[0]+line2[0];
    for(int i=1;i<line1.size();i++){
        //dp两条装配线，并记录路径信息
        if(line1[i-1]+line1[i]<=line2[i-1]+cost2[i]+line1[i]){
            line1[i]=line1[i-1]+line1[i];
            route[i]=1;
        }
        else{
            line1[i]=line2[i-1]+cost2[i]+line1[i];
            route[i]=2;
        }
        if(line2[i-1]+line2[i]<=line1[i-1]+cost1[i]+line2[i]){
            line2[i]=line2[i-1]+line2[i];
            route[i]=2;
        }
        else{
            line2[i]=line1[i-1]+cost1[i]+line2[i];
            route[i]=1;
        }
    }
    int size=line1.size()-1;
    //返回最终装配的最短路径
    return min(line1[size]+cost1[size+1],line2[size]+cost2[size+1]);
}




