#include <iostream>
#include <cstring>
#include <algorithm>
#include <vector>
#include <tuple>

using namespace std;

int pai[40010], vertice[40010];

void AddSet(int v) {
    pai[v] = v;
}

int find(int v) {
    if (pai[v] != v)
        return find(pai[v]);
    else
        return v;               
}

void Union(int a, int b) {
    a = find(a);
    b = find(b);
    if (a != b)
        pai[b] = a;
}

int main()
{
    int m, n, x, y, z;
    int mst;
    cin >> m >> n;
    while ((m && n) != 0)
    {
        memset(pai, 0, sizeof(pai));
        memset(vertice, 0, sizeof(vertice));
        tuple <int, int, int> aresta;
        vector<tuple <int, int, int>> arestas;
        for(int i = 0; i < m; i++)
        {
            vertice[i] = i;
            AddSet(i);
        }

        for (int i = 0; i < n; i++)
        {
            cin >> x >> y >> z;
            arestas.push_back(make_tuple(z, x, y));
        }
        sort(arestas.begin(), arestas.end());
        mst = 0;
        for (int i = 0; i < n; i++)
        {
            aresta = arestas[i];
            if(!(find(get<1>(aresta)) == find(get<2>(aresta))))
            {
                Union(get<1>(aresta), get<2>(aresta));
                mst = mst + get<0>(aresta);
            }
        }
        cout << mst << endl;  
        cin >> m >> n;
    }
    
    
    return 0;
}