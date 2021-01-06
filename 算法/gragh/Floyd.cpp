#include<iostream>
#include<algorithm>
#include<vector>
#include<stdio.h>
#define max 10000
using namespace std;

vector<vector<int> > Floyd(vector<vector<int> > &d){
	cout<<"FLOYD_WARSHALL: \n";
	int N=d.size(); 
	for (int k = 0; k<N; k++){
            for (int i = 0; i<N; i++){
                for (int j =0; j<N; j++){
                    d[i][j] = min(d[i][j], d[i][k] + d[k][j]);
                }
            }
        cout<<"第"<<k+1<<"次迭代："<<endl; 
        for(int i=0;i<6;i++){
			for(int j=0;j<6;j++){
				if(d[i][j]>9000)
					printf("%8s","INF");
				else
					printf("%8d",d[i][j]);
				}
			cout<<endl;
			}
            
        }
    
	return d;
}
int main() {
	vector<vector<int> >W={{0,max,max,max,-1,max},{1,0,max,2,max,max},{max,2,0,max,max,-8},
							{-4,max,max,0,3,max},{max,7,max,max,0,max},{max,5,10,max,max,0} };
	
	vector<vector<int> >d=Floyd(W);
	cout<<"最终结果 ： "<<endl;
	for(int i=0;i<6;i++){
			for(int j=0;j<6;j++){
				if(d[i][j]>9000)
					printf("%8s","INF");
				else
					printf("%8d",d[i][j]);
				}
			cout<<endl;
			}
	
	return 0;
}
