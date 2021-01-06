//
// Created by 叫我浑醉好了 on 2020/4/21.
//
#include "liblys.h"
int Longest_Common_Seq(string A,string B){
    //A,B序列的长度
    int n=A.size();
    int m=B.size();
    //dp袋
    vector<vector<int>> C(n+1,vector<int>(m+1,0));
    for(int i=0;i<n;i++){
        for(int j=0;j<m;j++){
            //最优子结构
            if(A[i]==B[j]){
                C[i+1][j+1]=C[i][j]+1;
            }
            else{
                C[i+1][j+1]=max(C[i][j+1],C[i+1][j]);
            }
            cout<<i+1<<","<<j+1<<" :"<<C[i+1][j+1]<<endl;
        }

    }
    return C[n][m];
}
