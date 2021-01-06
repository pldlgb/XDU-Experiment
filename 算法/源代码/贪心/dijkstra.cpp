#include<iostream>
#include<algorithm>
#include<vector>
#include<stdio.h>

using namespace std;
vector<int> dijsktra_1(vector<vector<int> > &G,int s);
int main(){
	vector<vector<int> > G={{0,10,5,10000,10000},{10000,0,2,1,10000},{10000,3,0,9,2},{10000,10000,10000,0,4},{7,10000,10000,6,0}};
//	vector<vector<int> > G;
//	for(int i=0;i<5;i++){
//		G.push_back(a[i]);
//	}
	vector<int> dis=dijsktra_1(G,4);
	for(int i=0;i<5;i++){
		cout<<dis[i]<<"  ";
	}
	return 0;
} 
vector<int> dijsktra_1(vector<vector<int> > &G,int s){
	int inf=10000;
	int n=5;
	vector<int> visited(n,0);// 距离起始点的最短距离
	vector<int> dis(n,inf);// 是否已经得到最优解
	dis[s]=0; // 起始点
	int tmp=0;
	for(int j=0;j<n;j++){// 在还未确定最短路的点中，寻找到起始点距离最小的点 的点
		tmp=-1;
		for(int i=0;i<n;i++){
			if(visited[i]==0&&((tmp==-1)||dis[i]<dis[tmp]))
				tmp=i;
		}
		visited[tmp]=1;// t号点的最短路已经确定
		for(int i=0;i<n;i++){
			dis[i] = min(dis[i], dis[tmp] + G[tmp][i]); // 用t更新其他点的距离
		}
	}
	
	return dis;
	
}

