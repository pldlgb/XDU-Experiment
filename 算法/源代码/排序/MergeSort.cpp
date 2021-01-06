#include<iostream>
#include<vector> 
#include<algorithm>
using namespace std;
void MergeSort(vector<int> &nums,int p,int r);
void Merge(vector<int> &nums,int p,int q,int r);
//测试 
int main(){
	
	int a[5]={5,2,1,4,3};
	vector<int> nums(a,a+5);
	MergeSort(nums,0,4);
	
	for(int i=0;i<nums.size();i++){
		cout<<nums[i]<<" ";		
	}
	return 0;
} 
void MergeSort(vector<int> &nums,int p,int r){
	int n=nums.size();
	if(p<r){
		int q=(p+r)/2;
		MergeSort(nums,p,q);
		MergeSort(nums,q+1,r);
		Merge(nums,p,q,r);
	}
	return; 	
}
//合并过程 
void Merge(vector<int> &arr,int p,int q,int r){
	int *help = new int(r-p+1);	
	int p1=p,p2=q+1,i=0;
	//按照大小排好序放入help数组	
	while(p1<=q && p2<=r)	{		
		help[i++] = arr[p1]>arr[p2] ? arr[p2++] : arr[p1++];	
	}
	//如果有一个数组还有数据没有排完，直接插入help后	
	while(p1<=q)		
		help[i++] = arr[p1++];
	while(p2<=r)		
		help[i++] = arr[p2++]; 	
	//将help数组的数带回arr 
	for (int i=0;i<r-p+1;i++){
		arr[p+i] = help[i];	
		}
	return ;
}

