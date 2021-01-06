#include<iostream>
#include<vector> 
#include<algorithm>
using namespace std;
void MergeSort(vector<int> &nums,int p,int r);
void Merge(vector<int> &nums,int p,int q,int r);
//���� 
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
//�ϲ����� 
void Merge(vector<int> &arr,int p,int q,int r){
	int *help = new int(r-p+1);	
	int p1=p,p2=q+1,i=0;
	//���մ�С�ź������help����	
	while(p1<=q && p2<=r)	{		
		help[i++] = arr[p1]>arr[p2] ? arr[p2++] : arr[p1++];	
	}
	//�����һ�����黹������û�����ֱ꣬�Ӳ���help��	
	while(p1<=q)		
		help[i++] = arr[p1++];
	while(p2<=r)		
		help[i++] = arr[p2++]; 	
	//��help�����������arr 
	for (int i=0;i<r-p+1;i++){
		arr[p+i] = help[i];	
		}
	return ;
}

