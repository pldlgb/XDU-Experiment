#include<iostream>
#include<algorithm>
#include<vector>
#include<stdio.h>
#define max 10000
using namespace std;

vector<int> dijsktra_1(vector<vector<int> > &G,int s){
	int inf=10000;
	int n=5;
	vector<int> visited(n,0);
	vector<int> dis(n,inf);
	dis[s]=0;
	int tmp=0;
	for(int j=0;j<n;j++){
		tmp=-1;
		for(int i=0;i<n;i++){
			if(visited[i]==0&&((tmp==-1)||dis[i]<dis[tmp]))
				tmp=i;
		}
		visited[tmp]=1;
		for(int i=0;i<n;i++){
			dis[i] = min(dis[i], dis[tmp] + G[tmp][i]); 
		}
	}
	
	return dis;
	
}

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
	vector<vector<int> >W={{0,0,0,0,0,0,0},{max,0,max,max,max,-1,max},{max,1,0,max,2,max,max},{max,max,2,0,max,max,-8},
							{max,-4,max,max,0,3,max},{max,max,7,max,max,0,max},{max,max,5,10,max,max,0} };
	vector<int> h =bellman_ford(W,0);
	cout<<"h(v) :\n";
	for(int i=0;i<h.size();i++){
		cout<<h[i]<<' ';
	} 
	cout<<endl;
	for(int i=0;i<W.size();i++){
		for(int j=0;j<W.size();j++){
			if(W[i][j]<max){
				cout<<"W["<<i<<"]"<<"["<<j<<"] : ";
				W[i][j]+=h[i]-h[j];
				cout<<W[i][j]<<endl;
			}
		}
	}
	vector<vector<int> >res;
	for(int i=1;i<W.size();i++){
		vector<int> dis=dijsktra_1(W,i);
		for(int j=0;j<dis.size();j++){
				dis[j]+=h[j]-h[i]; 
				cout<<dis[j]<<"  ";
		}
		cout<<endl;
		
	}
	
	
	return 0;
}

