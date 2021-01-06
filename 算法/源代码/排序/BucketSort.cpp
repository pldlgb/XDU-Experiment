//
// Created by 叫我浑醉好了 on 2020/4/19.
//
#include "liblys.h"
vector<float> BucketSort(vector<float> &arr){
    vector<vector<float>> B(10);
    vector<float> res;
    for(auto i: arr){
        int loc=10*i;
        B[loc].push_back(i);
    }
    for(int i=0;i<10;i++){
        sort(B[i].begin(),B[i].end());
    }
    for(int i=0;i<10;i++){
        for(auto j:B[i])
//            cout<<j<<' ';
            res.push_back(j);
    }
    return res;
}
