#include<iostream>
#include<vector> 
#include<algorithm>
using namespace std;
vector<int> InsertSort(vector<int> &nums);
int main(){
	
	int a[5]={5,2,1,4,3};
	vector<int> nums(a,a+5);
	InsertSort(nums);
	
	for(int i=0;i<nums.size();i++){
		cout<<nums[i]<<" ";		
	}
	return 0;
} 

vector<int> InsertSort(vector<int> &nums){
	int n=nums.size();
	for(int i=1;i<n;i++){
		int tmp=nums[i];
		int j=i-1;
		while(j>=0&&nums[j]>tmp){
			//如果 nums[j]>tmp num[j]向后移一位 
			nums[j+1]=nums[j];
			j--;
		}
		//将num[i] 插入位置 
		nums[j+1]=tmp; 
	} 
	return nums;
}

