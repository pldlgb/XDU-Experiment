//
// Created by 叫我浑醉好了 on 2020/4/19.
//

#include "liblys.h"
//找到经过中线的最大子序列
vector<int> Max_Sub_Cross(vector<int> &A,int high,int mid,int low){
    int left_sum=0;
    int sum=0;
    int left_max;
    for(int i=mid;i>=low;i--){
        sum+=A[i];
        if(sum>left_sum){
            left_sum=sum;
            left_max=i;
        }
    }
    int right_sum=0;
    sum=0;
    int right_max;
    for(int j=mid+1;j<=high;j++){
        sum+=A[j];
        if(sum>right_sum){
            right_sum=sum;
            right_max=j;
        }
    }
    return {left_max,right_max,left_sum+right_sum};
}
//相当直观的分治
vector<int> Find_Sub_Max(vector<int> &A,int low,int high){
    if(low==high){
        return {low,high,A[low]};
    }
    else{
        int mid=low+(high-low)/2;
        vector<int>left=Find_Sub_Max(A,low,mid);
        vector<int>right=Find_Sub_Max(A,mid+1,high);
        vector<int>middle=Max_Sub_Cross(A,high,mid,low);
        if(left[2]>=right[2]&&left[2]>=middle[2]) return left;
        else if(left[2]<=right[2]&&right[2]>=middle[2]) return right;
        else return middle;

    }


}
