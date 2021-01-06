//
// Created by 叫我浑醉好了 on 2020/4/20.
//
#include "liblys.h"
#define inf INT_MAX;
vector<vector<int>> MCM(vector<int>& p){
    int n=p.size()-2;
    //矩阵s记录i，j，分割的位置.长度为n+1
    vector<vector<int>>s(n+1,vector<int>(n+1,0));
    //矩阵dp记录i，j的最小值
    vector<vector<int>>dp(n+1,vector<int>(n+1,0));
    //l是步长，表示l+1个矩阵相乘，直到n+1个矩阵相乘
    for(int l=1;l<=n;l++){
        //i表示矩阵连乘的最左矩阵
        for(int i=0;i<=n-l;i++){
            //j表示矩阵连乘的最右矩阵
            int j=i+l;
            dp[i][j]=inf;
            //将矩阵连乘分解为i~k,k+1~j  k从i到j-1
            for(int k=i;k<=j-1;k++){
                int q=dp[i][k]+dp[k+1][j]+p[i]*p[k+1]*p[j+1];
                if(q<dp[i][j]){
                    dp[i][j]=q;
                    s[i][j]=k;
                }
            }
            cout<<dp[i][j]<<" ";
        }
    }
    cout<<endl;
    cout<<dp[0][n];
    return s;
}
