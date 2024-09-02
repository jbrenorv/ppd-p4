#include <bits/stdc++.h>
#define MAXN 1000007
using namespace std;

vector<int> p2(MAXN);
void get_p2(int n) {
    p2[0]=1;
    for (int i=1; i<=n; ++i) {
        p2[i] = (p2[i-1] * 2)%1000000007;
    }
}

vector<int> primes;
vector<bool> is_prime(MAXN, true);
void get_primes() {
    is_prime[0] = is_prime[1] = false;
    for (int i=2; (i*i)<MAXN; ++i) {
        if (!is_prime[i]) continue;
        primes.push_back(i);
        for (int j=(i*i); j<MAXN; j += i) {
            is_prime[j] = false;
        }
    }
}

void get_pf(int x, map<int,pair<int,int>>& pf) {
    vector<int> x_primes;
    for (int p : primes) {
        if (is_prime[x]) {
            x_primes.push_back(x);
            break;
        }
        if (x%p == 0) x_primes.push_back(p);
        while (x%p == 0) x /= p;
    }
    int k=(int)x_primes.size();
    for (int mask=1; mask<(1 << k); ++mask) {
        int p=1, q=__builtin_popcount(mask);
        for (int i=0; i<k; ++i) {
            if (mask & (1 << i)) {
                p *= x_primes[i];
            }
        }
        ++pf[p].first;
        pf[p].second = q;
    }
}

void f() {
    int n,q,x;
    cin >> n;
    get_p2(n);
    map<int,pair<int,int>> pf;
    for (int i=0; i<n; ++i) {
        cin >> x;
        get_pf(x, pf);
    }
    cin >> q;
    while (q--) {
        cin >> x;
        map<int,pair<int,int>> x_pf;
        get_pf(x, x_pf);
        long long exp=(long long)n;
        for (const auto &[k,v]: x_pf) {
            if (v.second & 1) exp -= pf[k].first;
            else exp += pf[k].first;
        }
        cout << p2[exp] << '\n';
    }
}

signed main() {
    ios::sync_with_stdio(0), cin.tie(0), cout.tie(0);
    get_primes();
    f();
}
