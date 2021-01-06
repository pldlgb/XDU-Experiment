//
// Created by 叫我浑醉好了 on 2020/4/19.
//
#include "liblys.h"

vector<int> CountSort(vector<int> &arr){
    int max_num=*max_element(arr.begin(),arr.end())+1;
    vector<int> count(max_num,0);
    for(auto i:arr){
        count[i]++;
    }
    for(int i=2;i<max_num;i++){
        count[i]+=count[i-1];
    }
    vector<int> res(arr.size(),0);
    for(int j=arr.size()-1;j>=0;j--){
        int elem=arr[j];
        res[count[elem]-1]=elem;
        count[elem]--;
    }
    return res;
}

