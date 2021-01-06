#include<iostream>
#include<algorithm>
#include<vector>
#include<stdio.h>
#define max 10000
using namespace std;

vector<vector<int> > EXTEND_SHORTEST_PATHS(vector<vector<int> > &L,vector<vector<int> > &W){
	int n=L.size();
	vector<vector<int> > res=L;
	for(int i=0;i<n;i++){
		for(int j=0;j<n;j++){
			for(int k=0;k<n;k++){
				res[i][j]=min(res[i][j],res[i][k]+W[k][j]);
			}
		}
	}
	return res;
}
vector<vector<int> >SLOW_ALL_PAIRS_SHORTEST_PATHS(vector<vector<int> >&W) {
	cout<<"SLOW_ALL_PAIRS_SHORTEST_PATHS:\n";
	int n=W.size();
	vector<vector<int> >L=W;
	int m=2;
	int times=1;
	while(m<n){
		L=EXTEND_SHORTEST_PATHS(L,W);
		cout<<"第"<<times++<<"次迭代："<<endl; 
        for(int i=0;i<6;i++){
			for(int j=0;j<6;j++){
				if(L[i][j]>9000)
					printf("%8s","INF");
				else
					printf("%8d",L[i][j]);
				}
			cout<<endl;
			}
		m=m+1;
	}
	return L;
}

vector<vector<int> >FAST_ALL_PAIRS_SHORTEST_PATHS(vector<vector<int> >&W) {
	cout<<"FAST_ALL_PAIRS_SHORTEST_PATHS:\n";
	int n=W.size();
	vector<vector<int> >L=W;
	int m=1;
	int times=1;
	while(m<n){
		L=EXTEND_SHORTEST_PATHS(L,L);
		cout<<"第"<<times++<<"次迭代："<<endl; 
        for(int i=0;i<6;i++){
			for(int j=0;j<6;j++){
				if(L[i][j]>9000)
					printf("%8s","INF");
				else
					printf("%8d",L[i][j]);
				}
			cout<<endl;
			}
		m=m*2;
	}
	return L;
}
int main() {
	vector<vector<int> >W={{0,max,max,max,-1,max},{1,0,max,2,max,max},{max,2,0,max,max,-8},
							{-4,max,max,0,3,max},{max,7,max,max,0,max},{max,5,10,max,max,0} };
	
	vector<vector<int> >L=SLOW_ALL_PAIRS_SHORTEST_PATHS(W);
	cout<<"最终结果 ： "<<endl;
	for(int i=0;i<L.size();i++){
			for(int j=0;j<L.size();j++){
				if(L[i][j]>9000)
					printf("%8s","INF");
				else
					printf("%8d",L[i][j]);
				}
			cout<<endl;
			}
	
	return 0;
}
