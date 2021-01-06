//
// Created by 叫我浑醉好了 on 2020/4/22.
//
#include "liblys.h"
//S[]={1,3,0,5,3,5,6,8,8,2,12}
//F[]={4,5,6,7,8,9,10,11,12,13,14}

vector<int> ActivitySelection(vector<int> S,vector<int> F,int i,int j){
    vector<int> res;
    //将排好序的第一个活动打入res
    res.push_back(i);

    for(int m=i+1;m<j;m++){
        //找到在活动i结束后开始的第一个活动
        if(m<j&&S[m]>=F[i]){
            res.push_back(m);
            i=m;
        }
    }

    return res;
}
