class EncType:
    seqcounter = 1
    kmtotalizer = 7

class _Enc:
    def __init__(self, clauses, nv):
        self.clauses, self.nv = clauses, nv

def _atmost(lits, k, top):
    cl = []
    n = len(lits)
    if k >= n:
        return cl, top
    if k <= 0:
        return [[-l] for l in lits], top
    s = []
    for i in range(n):
        s.append(list(range(top + 1, top + k + 1)))
        top += k
    for i in range(n):
        cl.append([-lits[i], s[i][0]])
        if i > 0:
            for j in range(k):
                cl.append([-s[i - 1][j], s[i][j]])
            for j in range(1, k):
                cl.append([-lits[i], -s[i - 1][j - 1], s[i][j]])
            cl.append([-lits[i], -s[i - 1][k - 1]])
    return cl, top

class CardEnc:
    @staticmethod
    def atmost(lits, bound=1, top_id=None, encoding=None):
        top = top_id if top_id is not None else max(abs(l) for l in lits)
        cl, top = _atmost(list(lits), bound, top)
        return _Enc(cl, top)

    @staticmethod
    def equals(lits, bound=1, top_id=None, encoding=None):
        lits = list(lits)
        top = top_id if top_id is not None else max(abs(l) for l in lits)
        a, top = _atmost(lits, bound, top)
        b, top = _atmost([-l for l in lits], len(lits) - bound, top)
        return _Enc(a + b, top)
