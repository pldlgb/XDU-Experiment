//
// Created by 叫我浑醉好了 on 2020/4/19.
//
#include "liblys.h"
//用贪心算法求取最长子序列
int GreedySubMax(vector<int> &A){
    int sum=0;
    int res=0;
    int left=0;
    int right=0;
    int low=0,high=0;
    for(auto i:A){
       // sum=max(i,sum+i);
//        res=max(sum,res);

//当前值与之前sum+i比较，并记录sum值的始终
        if(i>=sum+i){
            left=i;
            right=i;
            sum=i;
        }
        else{
            right=i;
        }
        //当前值与sum比较，如改变更新res值的始终
        if(sum>res){
            low=left;
            high=right;
            res=sum;
        }

    }
    cout<< low<<endl;
    cout<< high<<endl;
    return res;
}
