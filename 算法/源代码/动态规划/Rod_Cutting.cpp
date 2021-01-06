//
// Created by 叫我浑醉好了 on 2020/4/20.
//
#include "liblys.h"
vector<int> Rod_Cutting(vector<int> p,int n){
    vector<int> r(n+1,0);
    //从长度为一开始计算到长度为n
    for(int i=1;i<n+1;i++){
        //为r[i]赋初值
        r[i]=INT16_MIN;
        //将i长的木条分为 1~(n-1),2~n-2,...,n-1~1,n~0
        for(int j=1;j<=i;j++){
            //r[i]的迭代更新
            r[i]=max(r[i],p[j]+r[i-j]);
        }
    }
    return r;
}