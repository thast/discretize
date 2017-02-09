# from __future__ import division
# import numpy as np
# cimport numpy as np
# from libcpp.vector cimport vector


"""
    The Z-order curve is generated by interleaving the bits of an offset.

    See also:

        https://github.com/cortesi/scurve
        Aldo Cortesi <aldo@corte.si>

"""


def bitrange(long long x, int width, int start, int end):
    """
        Extract a bit range as an integer.
        (start, end) is inclusive lower bound, exclusive upper bound.
    """
    return x >> (width-end) & ((2**(end-start))-1)


def index(int dimension, int bits, int levelBits, list p, int level):
    cdef long long idx = 0
    cdef int iwidth
    cdef int i
    cdef long long b
    cdef int bitoff

    p = [_ for _ in p]

    p.reverse()
    iwidth = bits * dimension
    for i in range(iwidth):
        bitoff = bits-(i/dimension)-1
        poff = dimension-(i % dimension)-1
        b = bitrange(p[poff], bits, bitoff, bitoff+1) << i
        idx |= b

    return (idx << levelBits) + level


def point(int dimension, int bits, int levelBits, long long idx):
    cdef list p
    cdef int iwidth
    cdef int i, n
    cdef long long b

    n = idx & (2**levelBits-1)
    idx = idx >> levelBits

    p = [0]*dimension
    iwidth = bits * dimension
    for i in range(iwidth):
        b = bitrange(idx, iwidth, i, i+1) << (iwidth-i-1)/dimension
        p[i % dimension] |= b
    p.reverse()
    return p + [n]


# def _refineCell(int dimension, int bits, self, pointer):
#     self._structureChange()
#     pointer = self._asPointer(pointer)
#     ind = self._asIndex(pointer)
#     assert ind in self
#     h = self._levelWidth(pointer[-1])/2 # halfWidth
#     nL = pointer[-1] + 1 # new level
#     add = lambda p:p[0]+p[1]
#     added = []
#     def addCell(p):
#         i = self._index(p+[nL])
#         self._treeInds.add(i)
#         added.append(i)

#     addCell(map(add, zip(pointer[:-1], [0,0,0])))
#     addCell(map(add, zip(pointer[:-1], [h,0,0])))
#     addCell(map(add, zip(pointer[:-1], [0,h,0])))
#     addCell(map(add, zip(pointer[:-1], [h,h,0])))
#     if self.dim == 3:
#         addCell(map(add, zip(pointer[:-1], [0,0,h])))
#         addCell(map(add, zip(pointer[:-1], [h,0,h])))
#         addCell(map(add, zip(pointer[:-1], [0,h,h])))
#         addCell(map(add, zip(pointer[:-1], [h,h,h])))
#     self._treeInds.remove(ind)
#     return added
