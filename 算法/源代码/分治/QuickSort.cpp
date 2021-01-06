#include<iostream>
#include<vector> 
#include<algorithm>

using namespace std;
int partition(vector<int> &nums,int p, int r){
	int x=nums[r];
	int i=p-1;
	for(int j=p;j<r;j++){
		if(nums[j]<x){
			i++;
			swap(nums[i],nums[j]);
		}
	}
	swap(nums[++i],nums[r]);
	return i;
}
void QuickSort(vector<int> &nums,int p,int r){
	if(p<r){
		int q=partition(nums,p,r);
		//cout<<" This is Q: "<<q;
		QuickSort(nums,p,q-1);
		QuickSort(nums,q+1,r);
		
	}
	return ;
}
int main(){
	int a[8]={5,2,1,4,3,10,9,5};
	vector<int> nums(a,a+8);
	//InsertSort(nums);
	QuickSort(nums,0,7);
	
	for(int i=0;i<nums.size();i++){
		cout<<nums[i]<<" ";		
	}
	return 0;
} 
