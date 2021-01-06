#include<iostream>
#include<algorithm>
#include<vector>
#include<stdio.h>
#define max 10000
using namespace std;

vector<int> bellman_ford(vector<vector<int> > &G,int s){
	int n=G.size();
	vector<pair<int,int> > edge;
	for(int i=0;i<n;i++){
		for(int j=0;j<n;j++){
			if(i!=j&&G[i][j]<max)
			   edge.push_back({i,j});
		}
	}
	vector<int> dis(n,max);
	dis[s]=0;
	for(int i=0;i<n;i++){
		for(auto it : edge){
			if(dis[it.second]>dis[it.first]+G[it.first][it.second])
				dis[it.second]=dis[it.first]+G[it.first][it.second];
		}
	}
	for(auto it : edge){
			if(dis[it.second]>dis[it.first]+G[it.first][it.second])
				return {0};
		}
	return dis;
}
int main(){
	vector<vector<int> > G={{0,6,7,10000,10000},{10000,0,8,5,-4},{10000,10000,0,-3,9},{10000,-2,10000,0,10000},{2,10000,10000,4,0}};
//	vector<vector<int> > G;
//	for(int i=0;i<5;i++){
//		G.push_back(a[i]);
//	}
	vector<int> dis=bellman_ford(G,0);
	for(int i=0;i<5;i++){
		cout<<dis[i]<<"  ";
	}
	return 0;
} 
