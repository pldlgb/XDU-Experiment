//
// Created by 叫我浑醉好了 on 2020/4/20.
//
#include "liblys.h"
//给定一个大小为 n 的数组，找到其中的多数元素。多数元素是指在数组中出现次数大于 ⌊ n/2 ⌋ 的元素。
//使用分治法解决这个问题：将数组分成左右两部分，分别求出左半部分的众数 a1 以及右半部分的众数 a2，随后在 a1 和 a2 中选出正确的众数
int count_in_range(vector<int> &nums,int target,int low,int high){
    int count=0;
    for(int i=low;i<=high;i++){
        if(nums[i]==target)
            count++;
    }
    return count;
}
int Majority_Element(vector<int> &nums,int low,int high){
    if(low==high)
        return nums[low];
    else{
        int mid=low+(high-low)/2;
        int left_majority=Majority_Element(nums,low,mid);
        int right_majority=Majority_Element(nums,mid+1,high);
        if(count_in_range(nums, left_majority, low, high) > (high - low + 1) / 2)
            return left_majority;
        if(count_in_range(nums,right_majority,low,high)>(high-low+1)/2)
            return right_majority;
        return -1;
    }
}