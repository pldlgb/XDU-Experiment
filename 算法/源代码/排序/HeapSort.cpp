#include<iostream>
#include<vector> 
#include<algorithm>

using namespace std;

void heapify(vector<int> &nums,int root,int size){
	int left=root*2+1;
	int right=root*2+2;
	int large=root;
	//cout<<" size : "<<size<<endl; 
	//cout<<" root : "<<nums[root]<<endl;
	if(left<=size&&nums[left]>nums[root]){
		large=left;
	}
	if(right<=size&&nums[right]>nums[large]){
		large=right;
	}
	
	if(large!=root){
		//cout<<"这里交换 "<<nums[root]<<" 和 "<<nums[large]<<endl;
		 
		swap(nums[large],nums[root]);
		heapify(nums,large,size);
	}
}
void max_heap(vector<int> &nums){
	for(int i=(nums.size()/2);i>=0;i--){
		heapify(nums,i,nums.size()-1);
	}
	return;
}
void HeapSort(vector<int> &nums){
	//建立大顶堆 
	max_heap(nums);
//	for(int i=0;i<nums.size();i++){
//		cout<<nums[i]<<" ";		
//	}
//	cout<<endl; 
	//依次调整堆结构 
	for(int i=nums.size()-1;i>=1;i--){
		swap(nums[i],nums[0]);
		int size=i-1;
		heapify(nums,0,size);
	}
	return ;
}

int main(){
	int a[8]={5,2,1,4,3,10,9,5};
	vector<int> nums(a,a+8);
	//InsertSort(nums);
	HeapSort(nums);
	
	for(int i=0;i<nums.size();i++){
		cout<<nums[i]<<" ";		
	}
	return 0;
} 

